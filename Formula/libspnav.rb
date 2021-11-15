class Libspnav < Formula
  desc "Client library for connecting to 3Dconnexion's 3D input devices"
  homepage "https://spacenav.sourceforge.io"
  url "https://downloads.sourceforge.net/project/spacenav/spacenav%20library%20%28SDK%29/libspnav%200.2.3/libspnav-0.2.3.tar.gz"
  sha256 "7ae4d7bb7f6a5dda28b487891e01accc856311440f582299760dace6ee5f1f93"

  livecheck do
    url :stable
    regex(%r{url=.*?/libspnav[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "9c1fa37e3a61db6b730641e296d23495ec282ad38ebeec11e78fcf88ea063de0"
    sha256 cellar: :any,                 arm64_big_sur:  "421df09aff21f173833bb55fd801f83a8cdfb06855c27d02fcc1e0a22cf79991"
    sha256 cellar: :any,                 monterey:       "2bb7289ac82328298256386641456bd3e60716613177d34074a3c349966dba22"
    sha256 cellar: :any,                 big_sur:        "8260c77f747105cff878f66c1c622d9138cb8040c3423b87f5fdfd85ae0a4698"
    sha256 cellar: :any,                 catalina:       "9d7234296b1bdb5c4dd0f1aa5855cca877d2eba7fa83812c34438e7cf401a3cf"
    sha256 cellar: :any,                 mojave:         "a428a0b1037ff3dfd5a7ba2463f6ca96717e69be734627d8d7abd079f17fb7d5"
    sha256 cellar: :any,                 high_sierra:    "d61c3082aef6a700ad02d553304add7bb6bb2541236a97cf0a571dcc88f67d16"
    sha256 cellar: :any,                 sierra:         "55cf0552148451302bb50c04a843d8d3834ca95a38c79bf5270f20ac49f82d41"
    sha256 cellar: :any,                 el_capitan:     "48685db33ebe4acb821b33dbd609f95d03c47bd6c316b08f1bc1110d86271643"
    sha256 cellar: :any,                 yosemite:       "87bf93469bb14eef1a24de81cd521f6a62363a6aa7c04a319f3f18905de039b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9c755ddda17eddc3ee679f19f0a7528a894791ac4e0440658f755f630230ae2c"
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
