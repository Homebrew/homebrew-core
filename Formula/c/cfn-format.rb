class CfnFormat < Formula
  desc "Command-line tool for formatting AWS CloudFormation templates"
  homepage "https://github.com/aws-cloudformation/rain"
  url "https://github.com/aws-cloudformation/rain/archive/refs/tags/v1.24.3.tar.gz"
  sha256 "f56190d874985e0bcea79cc1ca233846173164d000f0c4f1d0051f2e26fee20b"
  license "Apache-2.0"
  head "https://github.com/aws-cloudformation/rain.git", branch: "main"

  livecheck do
    formula "rain"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c1cbf54b75dac8f686a9176695e36c8a19b7f1348c48bc6cbee54d50e2cdd2fe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c1cbf54b75dac8f686a9176695e36c8a19b7f1348c48bc6cbee54d50e2cdd2fe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c1cbf54b75dac8f686a9176695e36c8a19b7f1348c48bc6cbee54d50e2cdd2fe"
    sha256 cellar: :any_skip_relocation, sonoma:        "9ad2b2f3e6a2f37ede5890763da0160c3841139e2dd4eeb21ac93c3f5c220fde"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f09a902f3d62d6dbd2eb3134addfe36fc94797c32b1c4725cecec7b6f0ac396b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3df7df2e23aafcf4c60d8918eb1e7fa4c24abacf1f3cbd5607167dab9d91c4ab"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/cfn-format"
  end

  test do
    (testpath/"test.template").write <<~YAML
      Resources:
        Bucket:
          Type: AWS::S3::Bucket
    YAML
    assert_equal "test.template: formatted OK", shell_output("#{bin}/cfn-format -v test.template").strip
  end
end
