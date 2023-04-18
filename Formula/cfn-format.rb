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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "338f3bc5de9b315ea7ab578ca815574601d704b57e9f13f681e0a9fdf85266c1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "338f3bc5de9b315ea7ab578ca815574601d704b57e9f13f681e0a9fdf85266c1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "338f3bc5de9b315ea7ab578ca815574601d704b57e9f13f681e0a9fdf85266c1"
    sha256 cellar: :any_skip_relocation, ventura:        "cf2b540744f0ec9ac9578a83f6065f4629ae844352cb7498f28460859268f896"
    sha256 cellar: :any_skip_relocation, monterey:       "cf2b540744f0ec9ac9578a83f6065f4629ae844352cb7498f28460859268f896"
    sha256 cellar: :any_skip_relocation, big_sur:        "cf2b540744f0ec9ac9578a83f6065f4629ae844352cb7498f28460859268f896"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "20c38f6e6a5f833eb9273c2fb01b05ec028bfbcd5069b2acf06ce1c6e6558b5d"
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
