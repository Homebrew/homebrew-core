class Diffutils < Formula
  desc "File comparison utilities"
  homepage "https://www.gnu.org/s/diffutils/"
  url "https://ftp.gnu.org/gnu/diffutils/diffutils-3.5.tar.xz"
  mirror "https://ftpmirror.gnu.org/diffutils/diffutils-3.5.tar.xz"
  sha256 "dad398ccd5b9faca6b0ab219a036453f62a602a56203ac659b43e889bec35533"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "859f17793a93abdec6feeadfec6ea1775c7bca09c50a6fad88bfd93868820ab5" => :sierra
    sha256 "73ee52551558cb650c9af9667c83cf929244af2b39bd2285c950d73473c207fa" => :el_capitan
    sha256 "cc7870628c8e708863c3ab94f142d461e1a614a654d71a7dc325ebb1d4fe103b" => :yosemite
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"a").write "foo"
    (testpath/"b").write "foo"
    system bin/"diff", "a", "b"
  end
end
