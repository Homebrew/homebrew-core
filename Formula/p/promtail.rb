class Promtail < Formula
  desc "Log agent for Loki"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/refs/tags/v3.6.6.tar.gz"
  sha256 "de62ccf933e49a8db7cd3d375a28c69c2d66b0c2b64432cc6042f9137ad427b1"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    formula "loki"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b951df08c47eef86cf17b498e7be9f1cacd0e319e2704999f15cc8e4a5172d26"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7cf9080ad6c5689a48362d150b378b770dd4d54f2f49aeaa1b676f48ea185265"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "356b95c7b12f35d12d186c5631ba14307a68343474729f3fe94efa19af2939b9"
    sha256 cellar: :any_skip_relocation, sonoma:        "092d0f703f41927515d13bbdfa2b769f0258e12d483a227adc2c38ab6202ac41"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bb86dccfd14e9de7eaee8156c5023b61d612e94e0d5784be498c31cde4eb97b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3faf69d64967e6eea470e9cd1e827f8a59c47957ae0d0c8d3ae837edd3f9e205"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "systemd"
  end

  def install
    cd "clients/cmd/promtail" do
      system "go", "build", *std_go_args(ldflags: "-s -w")
      etc.install "promtail-local-config.yaml"
    end
  end

  service do
    run [opt_bin/"promtail", "-config.file=#{etc}/promtail-local-config.yaml"]
    keep_alive true
    working_dir var
    log_path var/"log/promtail.log"
    error_log_path var/"log/promtail.log"
  end

  test do
    port = free_port

    cp etc/"promtail-local-config.yaml", testpath
    inreplace "promtail-local-config.yaml" do |s|
      s.gsub! "9080", port.to_s
      s.gsub!(/__path__: .+$/, "__path__: #{testpath}")
    end

    spawn bin/"promtail", "-config.file=promtail-local-config.yaml"
    sleep 3
    sleep 3 if OS.mac? && Hardware::CPU.intel?

    output = shell_output("curl -s localhost:#{port}/metrics")
    assert_match "log_messages_total", output
  end
end
