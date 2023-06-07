class Promtail < Formula
  desc "Log agent for Loki"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/v2.8.2.tar.gz"
  sha256 "6abc2b7aed5e41ebaa151100ca67cd5f33a85568d112b89b2c525601327d6a77"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    formula "loki"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a424c9df71101c8e04050e02b17a6ac1ef6dbb956c480fcd21ed79ac787ad236"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a424c9df71101c8e04050e02b17a6ac1ef6dbb956c480fcd21ed79ac787ad236"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a424c9df71101c8e04050e02b17a6ac1ef6dbb956c480fcd21ed79ac787ad236"
    sha256 cellar: :any_skip_relocation, ventura:        "321e5e656be96742bc7c764ed70f8d2846f1435b3f8f95039006cd753e9b6096"
    sha256 cellar: :any_skip_relocation, monterey:       "321e5e656be96742bc7c764ed70f8d2846f1435b3f8f95039006cd753e9b6096"
    sha256 cellar: :any_skip_relocation, big_sur:        "321e5e656be96742bc7c764ed70f8d2846f1435b3f8f95039006cd753e9b6096"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "50b1015670a004f5e6c1507934f50fd30a3e9069d07ccd32e87098b7c3c053b8"
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

    fork { exec bin/"promtail", "-config.file=promtail-local-config.yaml" }
    sleep 3

    output = shell_output("curl -s localhost:#{port}/metrics")
    assert_match "log_messages_total", output
  end
end
