class Gforth < Formula
  desc "Implementation of the ANS Forth language"
  homepage "https://www.gnu.org/software/gforth/"
  url "https://www.complang.tuwien.ac.at/forth/gforth/gforth-0.7.3.tar.gz"
  sha256 "2f62f2233bf022c23d01c920b1556aa13eab168e3236b13352ac5e9f18542bb0"
  revision 1

  bottle do
    sha256 "a8696af411ccf1d3d94263442bb33f8692725acc96648d4b88410ef61f7c09b1" => :high_sierra
    sha256 "81f11da165dd91b2c8f4e030e053bce1a5d474be544f03d0199b18207156c1e7" => :sierra
    sha256 "942bca40ed6b1c85d4d5a3faf5c2742a48251e5cf36414965140f595ee758d04" => :el_capitan
    sha256 "20f29be370717f9ce22e224dd4f509c69fc557ff921d622b2525ea7e25bf9f0c" => :yosemite
    sha256 "d72074880ae4ab11e656645d0d9ab52630640fbb0df713c03fee1a6b8cd84ffa" => :mavericks
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
