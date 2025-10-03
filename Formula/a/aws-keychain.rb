class AwsKeychain < Formula
  desc "Uses macOS keychain for storage of AWS credentials"
  homepage "https://github.com/pda/aws-keychain"
  url "https://github.com/pda/aws-keychain/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "3c9882d3b516b629303ca9a045fc50f6eb75fda25cd2452f10c47eda205e051f"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "07b563b515bc0baa71f648ce63989009e50160d6ef87bd821e045be451cffb53"
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
