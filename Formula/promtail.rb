class Promtail < Formula
  desc "Log agent for Loki"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/v1.6.0.tar.gz"
  sha256 "6e83ac7b436c5721e914d23b56a8cff41118f81dda40b57d92aa8d8b2cf11834"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "70470c14896c1ed892a274541431b88938532a80982559c698f6e1a932017edf" => :catalina
    sha256 "47495ee7998dc8f9e6ccd2c8d601153d9e7f4d2ac70afadb44835bbef11ba5f5" => :mojave
    sha256 "62fa78cc81525e0141bc8dc3d1c3d0f0fead0e9ab0722ccb6566405d9a0abe82" => :high_sierra
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
