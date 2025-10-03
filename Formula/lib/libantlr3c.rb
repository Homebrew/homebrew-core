class Libantlr3c < Formula
  desc "ANTLRv3 parsing library for C"
  homepage "https://www.antlr3.org/"
  url "https://github.com/antlr/antlr3/archive/refs/tags/3.5.3.tar.gz"
  sha256 "a0892bcf164573d539b930e57a87ea45333141863a0dd3a49e5d8c919c8a58ab"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^(?:(?:antlr|release)[._-])?v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "c221434cbb3dd54168524ef68ab781c223a5d4c70f33b5602feba6c3ee31af69"
    sha256 cellar: :any,                 arm64_sequoia:  "0b28c958040567aca016c773fe2d184aaf8bfe2a849a20265cae9e8980685ae9"
    sha256 cellar: :any,                 arm64_sonoma:   "c6fe962be8632362af50b3eb0bf10fe363ddc153d3624c29d0b5d7fdc8e443b0"
    sha256 cellar: :any,                 arm64_ventura:  "f3a6b9556e0e61c22a8602a2a593fc286716a1613567476af5c534a443844e57"
    sha256 cellar: :any,                 arm64_monterey: "ee99e528c204f5aaa77e00b6ec513992a663b20077ca6c916e53e759c6d5b544"
    sha256 cellar: :any,                 arm64_big_sur:  "af63f0824ce2f3a819d2ddccbc92339a4f83432df923964ab2ce8d735ee682fd"
    sha256 cellar: :any,                 sonoma:         "44452d698280968ce15b8d7711a1ef1afc33d94cbecce5e1cfaebfe6d1a11393"
    sha256 cellar: :any,                 ventura:        "8fefe8f54568cd3eb22e0d5ac36fe8cbb13b9d1c3be7dda36c6c343b092515fb"
    sha256 cellar: :any,                 monterey:       "6f84f798670e1dc4e99d4633c05ec77a29c2f31075be4fd479f446bbb1468d7e"
    sha256 cellar: :any,                 big_sur:        "74fe108eded5a9480d78624421c87ebdcf4ea8e55ea95b994f00935f9c7016d2"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "23ffc02de7c8d3dd2b5db131e584aafd3d12c580a81ff7ff37f905d06214c54a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "89ea3b6e05a369ef0cf3d5ab56e1d98bd9a1507a77f5344da79b5ea12f7123f6"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    cd "runtime/C" do
      args = %w[
        --disable-antlrdebug
        --disable-debuginfo
        --enable-64bit
      ]
      args << "--disable-abiflags" if OS.linux? && Hardware::CPU.arm?

      system "autoreconf", "--force", "--install", "--verbose"
      system "./configure", *args, *std_configure_args.reject { |s| s["--disable-debug"] }
      system "make", "install"
    end
  end

  test do
    (testpath/"hello.c").write <<~C
      #include <antlr3.h>
      int main() {
        if (0) {
          antlr3GenericSetupStream(NULL);
        }
        return 0;
      }
    C
    system ENV.cc, "hello.c", "-L#{lib}", "-lantlr3c", "-o", "hello", "-O0"
    system testpath/"hello"
  end
end
