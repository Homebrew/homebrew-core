class Libbinio < Formula
  desc "Binary I/O stream class library"
  homepage "https://adplug.github.io/libbinio/"
  url "https://github.com/adplug/libbinio/releases/download/libbinio-1.5/libbinio-1.5.tar.bz2"
  sha256 "398b2468e7838d2274d1f62dbc112e7e043433812f7ae63ef29f5cb31dc6defd"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "6490acae30e6e1047e5770b4aab37e4c043488c5c2e8a8919962208c1da2cdd4"
    sha256 cellar: :any,                 big_sur:       "5ca7b1faccab23de4efee72cfe82244e419c40c78775f09a01e5669aeed4a8e1"
    sha256 cellar: :any,                 catalina:      "157efedae7e8169175623b12f91d8a786fdde524075a2a98a956e910aed5e507"
    sha256 cellar: :any,                 mojave:        "4c5b9085fdfe812e664f342e9da9504c24f2f2055c2ef939764dd4bd96025a23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5d8b2aeba35080348293ad101e8f4751c17e1d5b9e53adcc7e539f571bc19b01"
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--infodir=#{info}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      // test
      // do not change the line above!
      #include <libbinio/binfile.h>
      #include <string.h>

      int main(void)
      {
        binifstream     file("test.cpp");
        char            string[256];

        file.readString(string, 256, '\\n');

        return strcmp (string, "// test");
      }
    EOS
    system ENV.cxx, "test.cpp", "-I#{include}", "-L#{lib}", "-lbinio", "-o", "test"
    system "./test"
  end
end
