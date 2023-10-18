class Heartbeat < Formula
  desc "Lightweight Shipper for Uptime Monitoring"
  homepage "https://www.elastic.co/beats/heartbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.10.4",
      revision: "10b198c985eb95c16405b979c63847881a199aba"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c6557dbbed9b4e9dfe244bd182343ed7a2ec91b3a47f78c2b48ad347e033a953"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3284b1c1ec6a7af36075f2560fe6fa1efc8efa042ba995fcbe0c4e28f79573f9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c1ea02f7b5767ab5aab012d011840c6b7de93f0da1a1a6708818296228ec07fa"
    sha256 cellar: :any_skip_relocation, sonoma:         "32a086e437c04cb5a76c83e3392c08efb94a7ae717fd8e839703812f1f782439"
    sha256 cellar: :any_skip_relocation, ventura:        "c7378f196ada85a0ea3d5b092f49f531b6692cf384902f97d954c1fa897fa5bc"
    sha256 cellar: :any_skip_relocation, monterey:       "62860066d58889c1a59795d74d69a6b49e519784a4cc8bbbf245d6e571fdbfb7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "982a5fa5aee97dd2bdf6a7f9acf092c2f13fcb472dda2384946ed78495a41e80"
  end

  depends_on "go" => :build
  depends_on "mage" => :build

  uses_from_macos "python" => :build
  uses_from_macos "netcat" => :test

  def install
    # remove non open source files
    rm_rf "x-pack"

    cd "heartbeat" do
      # prevent downloading binary wheels during python setup
      system "make", "PIP_INSTALL_PARAMS=--no-binary :all", "python-env"
      system "mage", "-v", "build"
      ENV.deparallelize
      system "mage", "-v", "update"

      (etc/"heartbeat").install Dir["heartbeat.*", "fields.yml"]
      (libexec/"bin").install "heartbeat"
    end

    (bin/"heartbeat").write <<~EOS
      #!/bin/sh
      exec #{libexec}/bin/heartbeat \
        --path.config #{etc}/heartbeat \
        --path.data #{var}/lib/heartbeat \
        --path.home #{prefix} \
        --path.logs #{var}/log/heartbeat \
        "$@"
    EOS

    chmod 0555, bin/"heartbeat" # generate_completions_from_executable fails otherwise
    generate_completions_from_executable(bin/"heartbeat", "completion", shells: [:bash, :zsh])
  end

  def post_install
    (var/"lib/heartbeat").mkpath
    (var/"log/heartbeat").mkpath
  end

  service do
    run opt_bin/"heartbeat"
  end

  test do
    # FIXME: This keeps stalling CI when tested as a dependent. See, for example,
    # https://github.com/Homebrew/homebrew-core/pull/91712
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"].present?

    port = free_port

    (testpath/"config/heartbeat.yml").write <<~EOS
      heartbeat.monitors:
      - type: tcp
        schedule: '@every 5s'
        hosts: ["localhost:#{port}"]
        check.send: "hello\\n"
        check.receive: "goodbye\\n"
      output.file:
        path: "#{testpath}/heartbeat"
        filename: heartbeat
        codec.format:
          string: '%{[monitor]}'
    EOS
    fork do
      exec bin/"heartbeat", "-path.config", testpath/"config", "-path.data",
                            testpath/"data"
    end
    sleep 5
    assert_match "hello", pipe_output("nc -l #{port}", "goodbye\n", 0)

    sleep 5
    output = JSON.parse((testpath/"data/meta.json").read)
    assert_includes output, "first_start"

    (testpath/"data").glob("heartbeat-*.ndjson") do |file|
      s = JSON.parse(file.read)
      assert_match "up", s["status"]
    end
  end
end
