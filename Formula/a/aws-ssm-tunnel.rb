class AwsSsmTunnel < Formula
  desc "CLI tool to tunnel into RDS & ElastiCache over SSM-managed EC2 instances"
  homepage "https://github.com/ilkerispir/aws-ssm-tunnel"
  url "https://github.com/ilkerispir/aws-ssm-tunnel/archive/refs/tags/v0.0.1.tar.gz"
  sha256 "ba83bec1427a9a4997e3a4ff155138ed07ee7312d3a0b43075ca1dc092bfc4cf"
  license "Apache-2.0"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"aws-ssm-tunnel")
  end

  test do
    output = shell_output("#{bin}/aws-ssm-tunnel --help")
    assert_match "Usage", output
  end
end
