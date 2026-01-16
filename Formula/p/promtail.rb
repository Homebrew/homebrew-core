class Promtail < Formula
  desc "Log agent for Loki"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/refs/tags/v3.6.3.tar.gz"
  sha256 "1a47ed5aca892c9d0c55bfbf059b0efd8b75ae2c0140407f4d48f29bbc15d62e"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    formula "loki"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "384daf6ae27b5bf2ca440010a3d561e624681764a3f276421b9359b4cd4d109f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "882b8ab75e7efe50eb20ea8bc42d454c0651fd1dc6c79a6a8c74e02a398be258"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f60818369976d0b7b9e45c94170ef464cb48c89817562f16203b783579352ddb"
    sha256 cellar: :any_skip_relocation, sonoma:        "89a18cd7d750552ea9ce1b361ac4e6eb026445666fc82898c738ce1e06d0de2f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0c70e36ccfcd42140e230a3ccdecfa3e73f035c73bba442f02564ea9b7a1f574"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "19fcfaf8073413131637f8731847ecb2a4af7614c35903cd52d2fe5836ba7db9"
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
