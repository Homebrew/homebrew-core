class Doublecpp < Formula
  desc "Double dispatch in C++"
  homepage "https://doublecpp.sourceforge.io/"
  url "https://downloads.sourceforge.net/doublecpp/doublecpp-0.6.3.tar.gz"
  sha256 "232f8bf0d73795558f746c2e77f6d7cb54e1066cbc3ea7698c4fba80983423af"

  bottle do
    cellar :any_skip_relocation
    sha256 "eed3920bd4e85e32542ce2a67fc9d928f8d8ddfceb0b48e80ddd9db30090e9e6" => :mojave
    sha256 "ca161369434cba6763add99e4e470a495662c866a328b374c5d6184e687361cc" => :high_sierra
    sha256 "748af7fb63392453cc4b648cea20786173202f5c891b45765dbf374e4ac2c2d5" => :sierra
    sha256 "208aa405fce2959b47f705ab8ba9104e8eadec3e8e709bddd3117ef7b074bedf" => :el_capitan
    sha256 "54f99b448e61043c5152441c309ea849b1d04fbde12ab67e023aee074dc206ee" => :yosemite
    sha256 "cfd2231b9a8ecb53216905392c8e1aaa6841ea912f18dc6059d9ebfa1fa5f118" => :mavericks
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/doublecpp", "--version"
  end
end
