class Detox < Formula
  desc "Utility to replace problematic characters in filenames"
  homepage "https://detox.sourceforge.io/"
  url "https://github.com/dharple/detox/archive/v1.4.0.tar.gz"
  sha256 "9d201e4bf135e708e39bf4f46cfb2b8ce4ac6ceed54a2d87d30cca48b78af2a8"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_big_sur: "5fc638c886fbe24e55ac1391267c94a89b1225ebed8abc2867263c09779afa7f"
    sha256 big_sur:       "3238d5e066a6caa95aa195f33076013557808c93d0d8580361e3e7f7ef14c2e4"
    sha256 catalina:      "baacd18dacb6d6f7e860be0d09f16a1a2b3d88da595eaa26707ed6ecac874173"
    sha256 mojave:        "26e7f19c4266c7365dc07dbdda15311cccfc44cd3d4fad9244c495dcf54a0948"
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
