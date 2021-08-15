class Detox < Formula
  desc "Utility to replace problematic characters in filenames"
  homepage "https://detox.sourceforge.io/"
  url "https://github.com/dharple/detox/archive/v1.4.4.tar.gz"
  sha256 "83381789ccf43acc81eb0867d081475b0facb76a4dfa7fe566173d5e7b5d77c6"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_big_sur: "5816d99cfcefb904d5dce926869b415212321ef3caccdfdf4a6c6f9ba6e95f6c"
    sha256 big_sur:       "83f10052d44f3c4c0fd6fd96a24acde6c5babed73a241c21e5df28e1d15327ba"
    sha256 catalina:      "b19a68972142d3c4392d38e2b6d32e2b63767b0d3faf8d27cb8b0197eb50b820"
    sha256 mojave:        "f063f567cc0cde45b92ee8ab37481259aa832e9e117c96927a2838be6bfc90af"
    sha256 x86_64_linux:  "502f29bba32a3f877ea56f1a2ea2d8fd6f26a4a8eb181e4d69d19a2d1adde637"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    system "autoreconf", "-fiv"
    system "./configure", "--mandir=#{man}", "--prefix=#{prefix}"
    system "make"
    (prefix/"etc").mkpath
    pkgshare.mkpath
    system "make", "install"
  end

  test do
    (testpath/"rename this").write "foobar"
    assert_equal "rename this -> rename_this\n", shell_output("#{bin}/detox --dry-run rename\\ this")
  end
end
