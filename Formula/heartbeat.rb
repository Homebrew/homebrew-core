class Heartbeat < Formula
  desc "Lightweight Shipper for Uptime Monitoring"
  homepage "https://www.elastic.co/beats/heartbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.5.2",
      revision: "1ebd0940bd56943642ea8d63d1fe8227f86e7435"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c335958850c1a8ea24f677cf50d482a9def739a991b7fe05f2c3e6e0a9487dd8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ea64841832d68f3dbc5cf9555ec6203136b55e6427b05e7f49166c00e5158c86"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3f8cd940b5550c25c1ffa7807ad35b2a8908539bfdf336243456aa14f04018e5"
    sha256 cellar: :any_skip_relocation, monterey:       "df2a39a5b619e6a4cb6599c77af9910f1680c934383d3ebd5f45aee9e181de48"
    sha256 cellar: :any_skip_relocation, big_sur:        "8a095d327795366ee62235c35456be3e980f29ce3990ca32f691dfdb0a6fb94f"
    sha256 cellar: :any_skip_relocation, catalina:       "2b293f6cba1879f1156896862c9751feab45af5b67a0adcfbe7c4825147ca55a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c69a1d83e3d2c2d095d534efd277b3cb2560e8fdb1b2842030776f4169f1e41c"
  end

  depends_on "go" => :build
  depends_on "mage" => :build
  depends_on "python@3.11" => :build
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
