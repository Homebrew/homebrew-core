class CfnFormat < Formula
  desc "Command-line tool for formatting AWS CloudFormation templates"
  homepage "https://github.com/aws-cloudformation/rain"
  url "https://github.com/aws-cloudformation/rain/archive/refs/tags/v1.16.1.tar.gz"
  sha256 "0c73ddedd02317ec2cc80c183c0c60a6fc871aaff58602623d4e17668054aa8f"
  license "Apache-2.0"

  livecheck do
    formula "rain"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d46635d17ac329a93503c94812ab58092093274c8f623027ce2d916ada6aaf1d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d46635d17ac329a93503c94812ab58092093274c8f623027ce2d916ada6aaf1d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d46635d17ac329a93503c94812ab58092093274c8f623027ce2d916ada6aaf1d"
    sha256 cellar: :any_skip_relocation, sonoma:        "760181025f2456f25086bad0d36dbf4c536adba0c96239454a61fa178abe61cc"
    sha256 cellar: :any_skip_relocation, ventura:       "760181025f2456f25086bad0d36dbf4c536adba0c96239454a61fa178abe61cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f3f0b7bb6ce95fe44938d548ea8cfca9cf09e725e4247272006a7e5b11e94a7"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "cmd/cfn-format/main.go"
  end

  test do
    (testpath/"test.template").write <<~EOS
      Resources:
        Bucket:
          Type: AWS::S3::Bucket
    EOS
    assert_equal "test.template: formatted OK", shell_output("#{bin}/cfn-format -v test.template").strip
  end
end
