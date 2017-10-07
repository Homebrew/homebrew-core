
class Dia2code < Formula
  desc "Dia2Code is a small utility used to generate code from a Dia diagram."
  homepage "http://dia2code.sourceforge.net/download.html"
  url "http://prdownloads.sourceforge.net/dia2code/dia2code-0.8.3.tar.gz"
  sha256 "60d7d9e61ce0fe997cbcd9901a35d0dac4346e11f092c8277151cd2a3bed11b4"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "false"
  end
end
