class Lctr < Formula
  desc "Fast local file metadata search"
  homepage "https://github.com/NotTanJune/locator"
  url "https://github.com/NotTanJune/locator/archive/refs/tags/v0.1.41.tar.gz"
  sha256 "6f1415de83c2f37e0778c3493c14c19faa0c5e828f98c3cb734d2ae0371b3692"
  license "GPL-3.0-only"
  head "https://github.com/NotTanJune/locator.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "lctr 0.1.41", shell_output("#{bin}/lctr --version")
  end
end
