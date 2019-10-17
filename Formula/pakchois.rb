class Pakchois < Formula
  desc "PKCS #11 wrapper library"
  homepage "https://web.archive.org/web/www.manyfish.co.uk/pakchois/"
  url "https://web.archive.org/web/20161220165909/www.manyfish.co.uk/pakchois/pakchois-0.4.tar.gz"
  sha256 "d73dc5f235fe98e4d1e8c904f40df1cf8af93204769b97dbb7ef7a4b5b958b9a"

  bottle do
    cellar :any
    rebuild 1
    sha256 "0312304691fe567185eb8fe854d6ca036f887c39ae4ca5652cc53bd0f837cb44" => :catalina
    sha256 "5c6f1f39ca7bd268ba0df6f1f0f24a167aef86c77257fd6f8fccee7146b94c0d" => :mojave
    sha256 "0ff5336b2165a755efeab1185edcde604ddc77f3cc359d5c41a07f3d5d8b9c0f" => :high_sierra
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
