class Promtail < Formula
  desc "Log agent for Loki"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/v2.3.0.tar.gz"
  sha256 "c71174a2fbb7b6183cb84fc3a5e328cb4276a495c7c0be8ec53c377ec0363489"
  license "AGPL-3.0-only"

  livecheck do
    formula "loki"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "61a6d1f9f6f4ffc0cde6bf6fe908ef94fbe2d0a583eb4ff7f99255e02ac3fdc3"
    sha256 cellar: :any_skip_relocation, big_sur:       "2ac1bf4de911eaf2e6a0711dd22d87153e2503f50306bf768f12eb89b65a6be3"
    sha256 cellar: :any_skip_relocation, catalina:      "86f751b4b098921337fd4e2bf4cd7c38b81d795d2cca740a3a0713f860f099fa"
    sha256 cellar: :any_skip_relocation, mojave:        "450359cf7d3e027d4f13f17f9bdb80d35e80f8ad03ff5837c91f5120a84ef9b5"
  end

  depends_on "go" => :build

  def install
    cd "clients/cmd/promtail" do
      system "go", "build", *std_go_args
      etc.install "promtail-local-config.yaml"
    end
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
