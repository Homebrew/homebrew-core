class Gforth < Formula
  desc "Implementation of the ANS Forth language"
  homepage "https://www.gnu.org/software/gforth/"
  url "https://www.complang.tuwien.ac.at/forth/gforth/gforth-0.7.3.tar.gz"
  sha256 "2f62f2233bf022c23d01c920b1556aa13eab168e3236b13352ac5e9f18542bb0"
  revision 2

  bottle do
    cellar :any
    sha256 "e9063c35a2df4513ecb8c1aae8c02273c3da22487d90071db416c0b2b9bf1668" => :catalina
    sha256 "25fd07e36c780229c02e3243b7aa71c3b3b2744e1626409f6321ad2d99c67471" => :mojave
    sha256 "c5f42bd1b46307d521ccd626d7a5a4b030c48dd1788d4d580efb2d8aaa6d04bc" => :high_sierra
  end

  depends_on "emacs" => :build
  depends_on "libffi"
  depends_on "libtool"
  depends_on "pcre"

  def install
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version
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
