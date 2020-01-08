class Libspnav < Formula
  desc "Client library for connecting to 3Dconnexion's 3D input devices"
  homepage "https://spacenav.sourceforge.io"
  url "https://downloads.sourceforge.net/project/spacenav/spacenav%20library%20%28SDK%29/libspnav%200.2.3/libspnav-0.2.3.tar.gz"
  sha256 "7ae4d7bb7f6a5dda28b487891e01accc856311440f582299760dace6ee5f1f93"

  bottle do
    cellar :any
    sha256 "9d7234296b1bdb5c4dd0f1aa5855cca877d2eba7fa83812c34438e7cf401a3cf" => :catalina
    sha256 "a428a0b1037ff3dfd5a7ba2463f6ca96717e69be734627d8d7abd079f17fb7d5" => :mojave
    sha256 "d61c3082aef6a700ad02d553304add7bb6bb2541236a97cf0a571dcc88f67d16" => :high_sierra
    sha256 "55cf0552148451302bb50c04a843d8d3834ca95a38c79bf5270f20ac49f82d41" => :sierra
    sha256 "48685db33ebe4acb821b33dbd609f95d03c47bd6c316b08f1bc1110d86271643" => :el_capitan
    sha256 "87bf93469bb14eef1a24de81cd521f6a62363a6aa7c04a319f3f18905de039b1" => :yosemite
    sha256 "f425659deb611eacb94f2245f0c8f8235aa0169a422874f2aa2c32f8d207b84a" => :mavericks
  end

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --disable-x11
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <spnav.h>

      int main() {
        bool connected = spnav_open() != -1;
        if (connected) spnav_close();
        return 0;
      }
    EOS
    system ENV.cc, "test.cpp", "-I#{include}", "-L#{lib}", "-lspnav", "-o", "test"
    system "./test"
  end
end
