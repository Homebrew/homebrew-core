class Libbinio < Formula
  desc "Binary I/O stream class library"
  homepage "https://adplug.github.io/libbinio/"
  url "https://github.com/adplug/libbinio/releases/download/libbinio-1.5/libbinio-1.5.tar.bz2"
  sha256 "398b2468e7838d2274d1f62dbc112e7e043433812f7ae63ef29f5cb31dc6defd"
  license "LGPL-2.1-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "cf564d5b74db4094f9eb7cc697d1562e37fb5ee0ed26209f4ad0d257d19e8ec7"
    sha256 cellar: :any,                 arm64_sequoia:  "b907d94fd656bef05130d427f7327462a255838a0c36fbfa5dd3402053415a91"
    sha256 cellar: :any,                 arm64_sonoma:   "88b5cda150fa3563cdc3f7093ac8626c10f014ff5030b8e3a8e456b3eae509a2"
    sha256 cellar: :any,                 arm64_ventura:  "d47d5255715fc0638111c50a4ec1fe4eea4fd90409389331874df8ef76f61c08"
    sha256 cellar: :any,                 arm64_monterey: "3b66d91c0bc97b7ade4576bb7d54403ebbf4e22a46c1ad7a1eb165a5cec24368"
    sha256 cellar: :any,                 arm64_big_sur:  "6490acae30e6e1047e5770b4aab37e4c043488c5c2e8a8919962208c1da2cdd4"
    sha256 cellar: :any,                 sonoma:         "3936ef9646f007d48ddd044360f068e963f59e2cf7eed07f5de8a716cc7a18e7"
    sha256 cellar: :any,                 ventura:        "79dab1370400b3395c8370da7895c60ab281d3410820852787e8e16851bd22ee"
    sha256 cellar: :any,                 monterey:       "f2f87992d693266d8fc333fc9c583b8c372657da0018b24538d771598c76570c"
    sha256 cellar: :any,                 big_sur:        "5ca7b1faccab23de4efee72cfe82244e419c40c78775f09a01e5669aeed4a8e1"
    sha256 cellar: :any,                 catalina:       "157efedae7e8169175623b12f91d8a786fdde524075a2a98a956e910aed5e507"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "3e8aaef5849696b37c580d313eb29fd32a274eac256c9b83ad495bab4c06128d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5d8b2aeba35080348293ad101e8f4751c17e1d5b9e53adcc7e539f571bc19b01"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--infodir=#{info}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
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
    CPP
    system ENV.cxx, "test.cpp", "-I#{include}", "-L#{lib}", "-lbinio", "-o", "test"
    system "./test"
  end
end
