class Libuninameslist < Formula
  desc "Library of Unicode names and annotation data"
  homepage "https://github.com/fontforge/libuninameslist"
  url "https://github.com/fontforge/libuninameslist/releases/download/20260918/libuninameslist-dist-20260918.tar.gz"
  sha256 "deb2ec02640c232a4bc333c2cd301ee6b286914eeeb0ccc31ccafe326aed0029"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/v?(\d+(?:\.\d+)*)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "be30cf7255db988eb9d9de6f5cc6bea2f05b8cbd7e7d2a0212c3011da6c34da9"
    sha256 cellar: :any, arm64_tahoe:       "6ed38b913c30d8c8c10ddad1cb1cb40fb6148fb58a9f80b81df348166fc9beaf"
    sha256 cellar: :any, arm64_sequoia:     "0d934878052ae876f93d80748f0fdad7c0680227da6b0d85e697923cf98b6fcb"
    sha256 cellar: :any, arm64_linux:       "94c9829f9578e8069835a368504dd1e28d9230e8a39ce79d5861656958c31d0b"
    sha256 cellar: :any, x86_64_linux:      "05f11945ac79c613b461a3c7c8042dd57b259169335d78dfe74c3302268d0fcf"
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
