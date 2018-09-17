class Liboil < Formula
  desc "C library of simple functions optimized for various CPUs"
  homepage "https://wiki.freedesktop.org/liboil/"
  url "https://liboil.freedesktop.org/download/liboil-0.3.17.tar.gz"
  sha256 "105f02079b0b50034c759db34b473ecb5704ffa20a5486b60a8b7698128bfc69"

  bottle do
    cellar :any
    rebuild 1
    sha256 "e8655c3c54d78829199c130758a73dce27e27d8a925cb9ec943a1d32522c13f6" => :mojave
    sha256 "3214b8910deb69c2c0138a5ece603515c089fa2178ead16e4106695dd6b4c4b4" => :high_sierra
    sha256 "f242435c284690879f84812481843e92c54adc190a8201aa31d550c262e1951d" => :sierra
    sha256 "7d76b7a220caeb8dbaef27b879f4f3ac0ad5b236b563961abd9484e8bc9e0160" => :el_capitan
    sha256 "9ea78f801296e8643f366d634449a043376e9015e9329dc1c591a9ad55a37b66" => :yosemite
    sha256 "b7f92d53730febc590a12c4812784428e947c61361354c46f2fef245c0a51bba" => :mavericks
    sha256 "eaf6e1262d13a992443c25dd4d26acacb3c1e05851e8ec2a2e0a6cdd948885fe" => :mountain_lion
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  def install
    ENV.append "CFLAGS", "-fheinous-gnu-extensions" if ENV.compiler == :clang

    system "autoreconf", "-fvi"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <liboil/liboil.h>
      int main(int argc, char** argv) {
        oil_init();
        return 0;
      }
    EOS

    flags = ["-I#{include}/liboil-0.3", "-L#{lib}", "-loil-0.3"] + ENV.cflags.to_s.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
