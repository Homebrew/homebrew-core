class Presenterm < Formula
  desc "Terminal slideshow tool"
  homepage "https://github.com/mfontanini/presenterm"
  url "https://github.com/mfontanini/presenterm/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "755f2c868c4723f66490b5c3ff7297944d59b9c382efc5f0714787437cfac3ef"
  license "BSD-2-Clause"
  head "https://github.com/mfontanini/presenterm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "32e9ea4720555ef99bb5fa056cd48ed01869d66b311b738774ff577d44736783"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0931fd5bc071c7d232f92911979b0fa954c5992001785f9fa6a4e9776eeb6dd6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f7ff8a5713537c5d917f3b816e6bda13c91bdaf0e1fb5070e7117931ecb42f18"
    sha256 cellar: :any_skip_relocation, sonoma:        "d907f2cbad59b10f56be3285f140648950a233a0803226bd0b3fd724b9939c12"
    sha256 cellar: :any_skip_relocation, ventura:       "a37d714844a20661815bb943d549f5ddd773aa456edea98e3875ac9b11198e86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e83143fa91f1e69bb231709ca88a31f7c925cde4bbb282b7cbb8a8367c1d6975"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # presenterm is a TUI application
    assert_match version.to_s, shell_output("#{bin}/presenterm --version")
  end
end
