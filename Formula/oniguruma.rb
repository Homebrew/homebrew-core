class Oniguruma < Formula
  desc "Regular expressions library"
  homepage "https://github.com/kkos/oniguruma/"
  url "https://github.com/kkos/oniguruma/releases/download/v6.9.2/onig-6.9.2.tar.gz"
  sha256 "db7addb196ecb34e9f38d8f9c97b29a3e962c0e17ea9636127b3e3c42f24976a"

  bottle do
    cellar :any
    sha256 "1983059c2eae93f1e1ec1bdb65194c64b77182c444588c15085dcdf9095bac2a" => :mojave
    sha256 "5e39976b85f94f36dd7649e90c36d39a57d66bbf19cf827d0c610d09c21b7051" => :high_sierra
    sha256 "9ac5799494d065272c9bfaf40eeff57131d8e30142c95cba84e57e110a8b0de2" => :sierra
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match /#{prefix}/, shell_output("#{bin}/onig-config --prefix")
  end
end
