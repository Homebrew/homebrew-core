class AwsKeychain < Formula
  desc "Uses macOS keychain for storage of AWS credentials"
  homepage "https://github.com/pda/aws-keychain"
  url "https://github.com/pda/aws-keychain/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "3c9882d3b516b629303ca9a045fc50f6eb75fda25cd2452f10c47eda205e051f"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "133f33991e2bb9a17768272ab806e803b25935480f4eec03826c8ecfb3d93272"
  end

  # https://github.com/pda/aws-keychain/commit/c071a06bac9ebfef8fbbfbb883595c5dd0f38ce3
  deprecate! date: "2025-12-08", because: :unmaintained, replacement_formula: "aws-vault"
  disable! date: "2026-12-08", because: :unmaintained, replacement_formula: "aws-vault"

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
