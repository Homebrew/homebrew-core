class Libuninameslist < Formula
  desc "Library of Unicode names and annotation data"
  homepage "https://github.com/fontforge/libuninameslist"
  url "https://github.com/fontforge/libuninameslist/releases/download/20230916/libuninameslist-dist-20230916.tar.gz"
  sha256 "3ce49721de808a389f90997e9217adac449ab23e2fbf2115b22a8664e0e0a686"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/v?(\d+(?:\.\d+)*)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e6ed9ef9796b9c75ae9fc87a06086fe13438a8419cfcabe397565ba885540023"
    sha256 cellar: :any,                 arm64_ventura:  "afa81dd79c2050f909702d59949de7068fd20b51aa2e1f30b157df326e4dcc65"
    sha256 cellar: :any,                 arm64_monterey: "886013cdcb379d9e9fe6269cd532d390be6732725650faa2922fe84d4e5195d6"
    sha256 cellar: :any,                 arm64_big_sur:  "b89a7bc2308e856ad9a6bfcf111134e0263dd70f2b9b77772bbe73ec308062da"
    sha256 cellar: :any,                 sonoma:         "e129783b47f0afa99aeb358a86f2e23f79f9c827b9b8e5c1114ae26fba1991d5"
    sha256 cellar: :any,                 ventura:        "a4400a00217b7703a74c880e775da585231317ccf691890c9080744c426a0453"
    sha256 cellar: :any,                 monterey:       "91ee240ca7c52c2d568c26c67d1b0657d2d209d57b5c1bf009a0d768a7ca64cf"
    sha256 cellar: :any,                 big_sur:        "c22d7ef613246de66324665c1b2b7493f44d34d313ed8d19115bee41fc443968"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d5b8991beeec498b00b3bda0c37fa48e9f5539db72b47bebb597810f522b5422"
  end

  head do
    url "https://github.com/fontforge/libuninameslist.git", branch: "master"

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
