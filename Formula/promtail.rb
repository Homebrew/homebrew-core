class Promtail < Formula
  desc "Log agent for Loki"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/v2.0.0.tar.gz"
  sha256 "e7ab246d98be52caf7b475245f5ea2cf62fb00f61d6e5377f31423414847556b"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "06f2c343a982edbe5ab3428396ca883e9097db629d60504f84e5a247d96d53dd" => :catalina
    sha256 "7f0e19c930e2c6b56f5dd3b2b09c1222a5fd33956a85867772e67a9ccc683932" => :mojave
    sha256 "3b20f9947335d86303060d466851acb58a0366296d6e54d4d8afdc28ed29c215" => :high_sierra
  end

  depends_on "go" => :build

  def install
    cd "cmd/promtail" do
      system "go", "build", *std_go_args
      etc.install "promtail-local-config.yaml"
    end
  end

  test do
    port = free_port

    cp etc/"promtail-local-config.yaml", testpath
    inreplace "promtail-local-config.yaml" do |s|
      s.gsub! "9080", port.to_s
      s.gsub! /__path__: .+$/, "__path__: #{testpath}"
    end

    fork { exec bin/"promtail", "-config.file=promtail-local-config.yaml" }
    sleep 3

    output = shell_output("curl -s localhost:#{port}/metrics")
    assert_match "log_messages_total", output
  end
end
