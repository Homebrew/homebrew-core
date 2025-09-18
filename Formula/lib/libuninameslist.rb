class Libuninameslist < Formula
  desc "Library of Unicode names and annotation data"
  homepage "https://github.com/fontforge/libuninameslist"
  url "https://github.com/fontforge/libuninameslist/releases/download/20250909/libuninameslist-dist-20250909.tar.gz"
  sha256 "27b5e9667b668ce8a1623ad0ad52a2b9eeaeef8eb7a206ed1e5e4f5ec0980c85"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/v?(\d+(?:\.\d+)*)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a3e84512b948be72e684d84177739285ecbe37c426e442f2e7d2e02a6cd93b7f"
    sha256 cellar: :any,                 arm64_sequoia: "fe590da7284c3f01642f2b37d7512d1594c335c7f102a3433c076419f70fc9f7"
    sha256 cellar: :any,                 arm64_sonoma:  "7015b130ed8a7b77745d14ecff8b89e9f9843f1db1d64770bf63bda9eee99e27"
    sha256 cellar: :any,                 arm64_ventura: "131f89108facc8864df3deb235e9a67384b171471bf7d6b92f15ac0637a2a6f0"
    sha256 cellar: :any,                 sonoma:        "ef491e11d3824e2432df3738a04811a3af80b6599dc4c8f0a22a36dea85433f6"
    sha256 cellar: :any,                 ventura:       "80daa3f8aa26530bd841f8a7a794474bb82c57a7393f59eb2ab9ecc72624d7a6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e8ef2f4d15ed26bf40a151b3bfe8744749e6192119a5bcf5cce3595640a3ba80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "df6ffe164932e69cdfa9b177d3babc7d741d983df3225c9bf87bdd206eceb486"
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
