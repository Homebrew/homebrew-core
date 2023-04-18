class AwsKeychain < Formula
  desc "Uses macOS keychain for storage of AWS credentials"
  homepage "https://github.com/pda/aws-keychain"
  url "https://github.com/pda/aws-keychain/archive/v3.0.0.tar.gz"
  sha256 "3c9882d3b516b629303ca9a045fc50f6eb75fda25cd2452f10c47eda205e051f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ba317cf159adf639b08c5153cc69ded7671e948c7041a3fa441a6f34db6ec0ba"
  end

  depends_on :macos

  def install
    bin.install "aws-keychain"
  end

  test do
    # It is not possible to create a new keychain without triggering a prompt.
    assert_match "Store multiple AWS IAM access keys",
      shell_output("#{bin}/aws-keychain --help", 1)
  end
end
