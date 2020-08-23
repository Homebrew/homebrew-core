class Jpeg < Formula
  desc "Image manipulation library"
  homepage "https://www.ijg.org/"
  url "https://www.ijg.org/files/jpegsrc.v9d.tar.gz"
  mirror "https://dl.bintray.com/homebrew/mirror/jpeg-9d.tar.gz"
  mirror "https://fossies.org/linux/misc/jpegsrc.v9d.tar.gz"
  sha256 "99cb50e48a4556bc571dadd27931955ff458aae32f68c4d9c39d624693f69c32"
  license "IJG"

  bottle do
    cellar :any
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
