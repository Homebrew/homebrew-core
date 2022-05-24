class Cdk < Formula
  desc "Curses development kit provides predefined curses widget for apps"
  homepage "https://invisible-island.net/cdk/"
  url "https://invisible-mirror.net/archives/cdk/cdk-5.0-20211216.tgz"
  sha256 "aeec4d9be2255970c8dca0785a0a996f0d242eb4f73cf927a3ec04997a3e63e8"
  license "BSD-4-Clause-UC"

  livecheck do
    url "https://invisible-mirror.net/archives/cdk/"
    regex(/href=.*?cdk[._-]v?(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e0622cd358c0894225c95ae33fc2d093695a2089f54e7345ac706979fe01e7b7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b8026d50d6a5e03abd5c4562ab24a0bc77fb89ed39ba243caedfa1886837c03a"
    sha256 cellar: :any_skip_relocation, monterey:       "e3713ff6f335a35306170e4c3452f84c5af013534384052ce33b2f34d8dbfb90"
    sha256 cellar: :any_skip_relocation, big_sur:        "8226292cb72b671cf8c7dc6b26763fc3d102fd54a875b99cf0541d6b2f04f2e9"
    sha256 cellar: :any_skip_relocation, catalina:       "be5547b47d2c805c379cb4fb67561a16b00bfdfddd46397270f80e4cb4dea7bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "887f2d0af8339a126b988ba2f6a495a79613f5e9fcaa4ae68b154f9fce1cb6cd"
  end

  uses_from_macos "ncurses"

  def install
    system "./configure", "--prefix=#{prefix}", "--with-ncurses"
    system "make", "install"
  end

  test do
    assert_match lib.to_s, shell_output("#{bin}/cdk5-config --libdir")
  end
end
