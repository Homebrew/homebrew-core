class Heartbeat < Formula
  desc "Lightweight Shipper for Uptime Monitoring"
  homepage "https://www.elastic.co/beats/heartbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.13.2",
      revision: "d41b4978ea7b4d7c6020b47ffd8a3b8642531fe3"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "44a1b50f33ce7738e1df795b082f2bb8da19f4143cfe4d84d378997f71d0fc88"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e89e1dfb14c8598cc88a3cb0b3e2fdeb76cabf948bdc4ea086a6437f7f62221a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c60f1702216e9ea2f679c0c87c79eb3ace6164a682d2f45e3fae5421b6cc1521"
    sha256 cellar: :any_skip_relocation, sonoma:         "c9bab4ccec266fb5d0d01e29ce854ad4c3aad1d8500740896b48c65ab827736c"
    sha256 cellar: :any_skip_relocation, ventura:        "bada52daec7be966047c6d8fe689eea0517af41c2a5cfeb40f2ad12c51e93efc"
    sha256 cellar: :any_skip_relocation, monterey:       "914587b1d349ea9c3dc23d97a985ef26f17708064e4c2b2ce1b2bde8fe94a3d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "92fb6555d9c194c965e261de2a04b9365c4cb8b4c83d199ad2ba45590db174ff"
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
