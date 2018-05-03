class Libofx < Formula
  desc "Library to support OFX command responses"
  homepage "https://libofx.sourceforge.io"
  url "https://downloads.sourceforge.net/project/libofx/libofx/libofx-0.9.13.tar.gz"
  sha256 "57eaf97cddbaf82c24f26b8f5cf8b2fbfd4969c74500a2c9acc9082b83bcc0e4"

  bottle do
    sha256 "b682be169269451309ccc7827782a66489e8cf3c9b1793a6b03aa51fd1a943e6" => :high_sierra
    sha256 "74ccac1d72a7c16eb296c19ea7396f504ab7428aa0b302a84629cd00ef64d6ac" => :sierra
    sha256 "1e5b91a3e74e5bf3f8ae5ac577a0ad1c81c679a328abee6770b9671fd678456d" => :el_capitan
  end

  depends_on "open-sp"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_equal "ofxdump #{version}", shell_output("#{bin}/ofxdump -V").chomp
  end
end
