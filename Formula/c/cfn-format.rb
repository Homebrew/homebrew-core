class CfnFormat < Formula
  desc "Command-line tool for formatting AWS CloudFormation templates"
  homepage "https://github.com/aws-cloudformation/rain"
  url "https://github.com/aws-cloudformation/rain/archive/refs/tags/v1.8.3.tar.gz"
  sha256 "47ff89511181b9e79abc1a9491d551417b66a515f32c09bd5b278aeba3a03937"
  license "Apache-2.0"

  livecheck do
    formula "rain"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a5a3f9f88ffa7c8a4f9c914a3ba73c99a89fa1f197cc2d2aa07be266494fdfcc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e1d610524f72d6019b051fac958706a2c04032a0617195acd7918fd1c2b6b9ae"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b3bcf8846bc277bf18eb644bf1bc2b64606400ca4e1049552df492364419d35a"
    sha256 cellar: :any_skip_relocation, sonoma:         "f36cb80a099136faa48cbe77ccb7da8b496b376c0544aec249ee167a9cc1a88c"
    sha256 cellar: :any_skip_relocation, ventura:        "2702b81a1f7d6a91ed76d18efb6b2824d9880b5c2fec98b6548af2b23e88a853"
    sha256 cellar: :any_skip_relocation, monterey:       "e9ee87163099ca199d03a42f6852a126f95f14ffb08787048b62becd8122f945"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4e2044d36ecc87c2acea313348370e4e9880c441ce0325b367794ca6689bd54f"
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
