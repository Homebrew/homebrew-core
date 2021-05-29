class M4 < Formula
  desc "Macro processing language"
  homepage "https://www.gnu.org/software/m4"
  url "https://ftp.gnu.org/gnu/m4/m4-1.4.19.tar.xz"
  mirror "https://ftpmirror.gnu.org/m4/m4-1.4.19.tar.xz"
  sha256 "63aede5c6d33b6d9b13511cd0be2cac046f2e70fd0a07aa9573a04a82783af96"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1db2471add366dde3b52f8d2d32e6d118584f91d1390d8efd6c10c41c9d6a45c"
    sha256 cellar: :any_skip_relocation, big_sur:       "0df9083b268f76a3cda0c9f0d2ce84b51d21a8618d578740646fb615b00c7e7b"
    sha256 cellar: :any_skip_relocation, catalina:      "2fdf452c94c6b63ea0a45608c19a4477acaf79853a298d337360971c5d51413b"
    sha256 cellar: :any_skip_relocation, mojave:        "2c0f28d612ba588cd6bf8380c6e286c9d3e585dcd8c4ad198b955c9e8cd1d817"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d49a50f79a4ad2f74f96496f4ea672354610de3da4cedf426145838ae574300"
  end

  keg_only :provided_by_macos

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match "Homebrew",
      pipe_output("#{bin}/m4", "define(TEST, Homebrew)\nTEST\n")
  end
end
