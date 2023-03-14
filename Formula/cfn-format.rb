class CfnFormat < Formula
  desc "Command-line tool for formatting AWS CloudFormation templates"
  homepage "https://github.com/aws-cloudformation/rain"
  url "https://github.com/aws-cloudformation/rain/archive/v1.3.3.tar.gz"
  sha256 "230db11449b34043dc9e10a009134bd5dca240dc20a5d12710b98606f62559a7"
  license "Apache-2.0"

  livecheck do
    formula "rain"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fec2aefcd14820a779cc3af0f4f52c3a5ebfd2206b1961c567fba037101f7e6e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fce7b18b861963f3801da27eef27fbfd78bfab9eae05b0348fd543d08a87c725"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9b566ec3621defa9035a0b5125dcd4ce2571fca355455bc097d9e107e09884d9"
    sha256 cellar: :any_skip_relocation, ventura:        "e867403ed1486bf6ed7b24ab1efbd2e2504a0e750b813d38aa583e56c2644612"
    sha256 cellar: :any_skip_relocation, monterey:       "add667784489bcfdc095dec12dad96ca00b2bdfc93dc14801c0e71c5715c6933"
    sha256 cellar: :any_skip_relocation, big_sur:        "f755c169cbb9b9044a86dcada939183e3d073d0217eb83ec2194e3332bb31a58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5ab882c17b5549a6e3cd5dfbe4e3b52a23f06ca76bc1035d4f2ca9466406c235"
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
