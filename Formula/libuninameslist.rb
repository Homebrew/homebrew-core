class Libuninameslist < Formula
  desc "Library of Unicode names and annotation data"
  homepage "https://github.com/fontforge/libuninameslist"
  url "https://github.com/fontforge/libuninameslist/releases/download/20221022/libuninameslist-dist-20221022.tar.gz"
  sha256 "92c833936d653b2f205fb5e7ac82818311824dabdc7abdc2e81f07c3a0ea39bb"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)*)["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e1f92764ac97ebac5e76e2cc88414e9b4272c791159b92751b44b8b1b16f88f8"
    sha256 cellar: :any,                 arm64_monterey: "b730c8d395fff31ba541759c101e3024b9652c05aa426ca08b41f996afa49e7f"
    sha256 cellar: :any,                 arm64_big_sur:  "4b0214eea454a0b9be8a49a37146519750abd9a384c397a35e0fd7978007d211"
    sha256 cellar: :any,                 ventura:        "ea76dda1784a20ed1a884903618a73c57d66c69c9d0f1b40c050362c70d787ec"
    sha256 cellar: :any,                 monterey:       "85eef665f0db7618b40ed7710b0677c098745a4c429c5f5ef70b4647f5fa2774"
    sha256 cellar: :any,                 big_sur:        "24cebce234e974de93316eacc50b2bb4eef5aa68463fa2d4762b5a4103d87388"
    sha256 cellar: :any,                 catalina:       "f7228caba01e8f69cf264d19822c6ae5fecddbc8c943911ab12df5d5c0539675"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0663619ead9a7ed939f94b7eb97d1be2b7239b35ed149e71c8605efbc171ff17"
  end

  head do
    url "https://github.com/fontforge/libuninameslist.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    if build.head?
      system "autoreconf", "-i"
      system "automake"
    end

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <uninameslist.h>

      int main() {
        (void)uniNamesList_blockCount();
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-luninameslist", "-o", "test"
    system "./test"
  end
end
