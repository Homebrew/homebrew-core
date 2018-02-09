class Gforth < Formula
  desc "Implementation of the ANS Forth language"
  homepage "https://www.gnu.org/software/gforth/"
  url "https://www.complang.tuwien.ac.at/forth/gforth/gforth-0.7.3.tar.gz"
  sha256 "2f62f2233bf022c23d01c920b1556aa13eab168e3236b13352ac5e9f18542bb0"
  revision 1

  bottle do
    sha256 "e73152fbd5f75b351386b1a7fcabfda3217af095cd3c1f196506922c0da02593" => :high_sierra
    sha256 "78ceb158d5997fc0acb797384e69cc4d530bfefe2b58bc3a43f2633fb5e7a8e2" => :sierra
    sha256 "6183073aa7dab4abe1fc65acf3cf371965efb31a8b8cbd9c0bbe49558817ac41" => :el_capitan
  end

  depends_on "emacs" => :build
  depends_on "libtool" => :run
  depends_on "libffi"
  depends_on "pcre"

  def install
    cp Dir["#{Formula["libtool"].opt_share}/libtool/*/config.{guess,sub}"], buildpath
    ENV.deparallelize
    system "./configure", "--prefix=#{prefix}"
    system "make", "EMACS=#{Formula["emacs"].opt_bin}/emacs"
    elisp.mkpath
    system "make", "install", "emacssitelispdir=#{elisp}"

    elisp.install "gforth.elc"
  end

  test do
    assert_equal "2 ", shell_output("#{bin}/gforth -e '1 1 + . bye'")
  end
end
