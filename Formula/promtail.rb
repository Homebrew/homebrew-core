class Promtail < Formula
  desc "Log agent for Loki"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/v2.2.0.tar.gz"
  sha256 "758fa26422bacda69b12e740e46fa5b97e02063a90fece14fb3fdcd7add2f7f5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "684dd470bba1ab702428bcc768e3ced16060837293ba9f12e34823215b5b138e"
    sha256 cellar: :any_skip_relocation, big_sur:       "3bc21b34bb977a87c4e8fe2bcd365db6e21b42233fc100d49bb60dd7a5bd71ed"
    sha256 cellar: :any_skip_relocation, catalina:      "8016c41a0ab1eeccbe0a79ee4c71fde464bdab004c62f4c6c6d8c165ad65a6f8"
    sha256 cellar: :any_skip_relocation, mojave:        "687056a4e2c498755da1c54af3cafc5d57743496772cfad92db615f3c1801362"
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
      s.gsub!(/__path__: .+$/, "__path__: #{testpath}")
    end

    fork { exec bin/"promtail", "-config.file=promtail-local-config.yaml" }
    sleep 3

    output = shell_output("curl -s localhost:#{port}/metrics")
    assert_match "log_messages_total", output
  end
end
