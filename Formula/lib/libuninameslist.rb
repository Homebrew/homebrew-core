class Libuninameslist < Formula
  desc "Library of Unicode names and annotation data"
  homepage "https://github.com/fontforge/libuninameslist"
  url "https://github.com/fontforge/libuninameslist/releases/download/20260107/libuninameslist-dist-20260107.tar.gz"
  sha256 "aadfaf62a96f20914d8dd248e8f19325471ead0cf3133b2f8ae0624c2da3657b"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/v?(\d+(?:\.\d+)*)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "53b985c29ff83f71b0dba677c75f7fc710f0f0649295258efd0d3d7ef95344a2"
    sha256 cellar: :any,                 arm64_sequoia: "c536b67396adcce357f243174654cbbe708b8be3ee655620236c867a8ceecbe5"
    sha256 cellar: :any,                 arm64_sonoma:  "a3e816eddacb78c8cd10d4139b142e8fbae5ee24b5170558d1314416ddc12a9b"
    sha256 cellar: :any,                 sonoma:        "fe1fb18127b16de2f48709a26873e90dfc20e01da58467589c3c281b4ae1b854"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "32ea5e402bcd2d9a72d7bd4a2e660bfd70e11e6cbbe06ca43b8938073e402b74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d0f4513836950d34e04e862392706ec2bc51e274d162e9dde35044b89e2564a8"
  end

  head do
    url "https://github.com/fontforge/libuninameslist.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    if build.head?
      system "autoreconf", "--force", "--install", "--verbose"
      system "automake"
    end

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <uninameslist.h>

      int main() {
        (void)uniNamesList_blockCount();
        return 0;
      }
    C
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-luninameslist", "-o", "test"
    system "./test"
  end
end
