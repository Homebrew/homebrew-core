class Jpeg < Formula
  desc "Image manipulation library"
  homepage "https://www.ijg.org/"
  url "https://www.ijg.org/files/jpegsrc.v9d.tar.gz"
  mirror "https://dl.bintray.com/homebrew/mirror/jpeg-9d.tar.gz"
  mirror "https://fossies.org/linux/misc/jpegsrc.v9d.tar.gz"
  sha256 "6c434a3be59f8f62425b2e3c077e785c9ce30ee5874ea1c270e843f273ba71ee"
  license "IJG"

  livecheck do
    url "https://www.ijg.org/files/"
    regex(/href=.*?jpegsrc[._-]v?(\d+[a-z]?)\.t/i)
  end

  bottle do
    cellar :any
    sha256 "c565929a4901365a3408b57275802f943625c1e29e1b48a186edd2e97d8c0bdb" => :big_sur
    sha256 "e511143cd72a76572dabe52cef0034996b2ed24334f1b3466ba339746230e37b" => :arm64_big_sur
    sha256 "8f7b82a952fb3937889c7f22da1403e5338cd320495917eb26b0c5b2e614791c" => :catalina
    sha256 "b931e7725c83275c56f962b51b83c10f31a01ac8d823c6722edaf16d893970b1" => :mojave
    sha256 "64286932634fbe1e0d07eacda334d2f4967b20bce0737424df56ec5eaa34ccca" => :high_sierra
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/djpeg", test_fixtures("test.jpg")
  end
end
