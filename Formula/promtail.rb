class Promtail < Formula
  desc "Log agent for Loki"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/v2.0.0.tar.gz"
  sha256 "e7ab246d98be52caf7b475245f5ea2cf62fb00f61d6e5377f31423414847556b"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "98a8c826668b4ec1af40730cc82f26d293cd33f03cecc4bfba917723de8b3487" => :catalina
    sha256 "ecec472508439e9b36d2e2f12363371ed3bfbe048115600110be0684bd851398" => :mojave
    sha256 "add5dc05140a531958e5bb521ed47d0038d442839bc21c75ecbe514f5944887a" => :high_sierra
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
