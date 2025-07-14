class Libuninameslist < Formula
  desc "Library of Unicode names and annotation data"
  homepage "https://github.com/fontforge/libuninameslist"
  url "https://github.com/fontforge/libuninameslist/releases/download/20240910/libuninameslist-dist-20240910.tar.gz"
  sha256 "e59aab324ca0a3a713fe85c09a56c40c680a8458438d90624597920b3ef0be26"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/v?(\d+(?:\.\d+)*)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "cf609c8bc13da0d2e48afb290124f6f40364d99ccd60d9cd90a5736cfd0a7b62"
    sha256 cellar: :any,                 arm64_sonoma:   "30162a392d8c3b38e0b54765ef6d3285b9b136123949df0dff2c6dd1850793b8"
    sha256 cellar: :any,                 arm64_ventura:  "ac5b3cf31a12f29e6f1c98d2dc20b6fb00c133f1ef25236ef1121034bb08c7d5"
    sha256 cellar: :any,                 arm64_monterey: "2ddbb3f6078bc8de3e9247846ae47bf71f9c9c70e76c3646af259247e217fa11"
    sha256 cellar: :any,                 sonoma:         "058a9be1c073ea75b776da75a266fdcc21fd3a20244705b2d426c91c16092bac"
    sha256 cellar: :any,                 ventura:        "44e94ef3192ab2052ec7c36460e307dbfd5e2aa75e445a1c285a4dc805bf81f0"
    sha256 cellar: :any,                 monterey:       "4ba6f06973d3507936496ade35a2ebe95e8b3fcaedfce6b82ba25274f6cc22be"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "a64c4667a64658502fdbfa6512dca1479c9b8721865ea9175983677c3cda405d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e69b85f779f074776a2f4d8da6a1ae610b3b1a8760192a9ab1aa392622c8492a"
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
