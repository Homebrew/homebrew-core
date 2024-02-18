class Heartbeat < Formula
  desc "Lightweight Shipper for Uptime Monitoring"
  homepage "https://www.elastic.co/beats/heartbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.12.1",
      revision: "c7ec8f634ed6052674762b32fa640087d32f165f"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3d5a4e7cd0ff4b2343cb6847744d28e71e5f4f441481e6bb1693ca8c4372fa82"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5d574c27f0754af3d68e4b7b49ceb69e4d77999567f523442c9f7a27b0c06235"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a4f5667020888fe23abe1487810ff7b70663c1efe09bc9bcc1289269e2ba9e4f"
    sha256 cellar: :any_skip_relocation, sonoma:         "7d39e6eaa6a4267beae2e4110651e8939a971d91ddd9d66d1c33a57152f61ab4"
    sha256 cellar: :any_skip_relocation, ventura:        "b1e14c0457656519798aa4ed79fe9f7690090ef4315269097a58d38547ecab1d"
    sha256 cellar: :any_skip_relocation, monterey:       "a16d8051f926cfbc8be97de1c57e892128fc2acfb2ced94b5470d7b92b67cf5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1b7ded097584ec541f57bfd71716ebeeaef29d577ec4740e6c1cb4dd6ddc2fa1"
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
