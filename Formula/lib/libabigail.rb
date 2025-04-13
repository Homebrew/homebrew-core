class Libabigail < Formula
  desc "ABI Generic Analysis and Instrumentation Library"
  homepage "https://sourceware.org/libabigail/"
  url "https://mirrors.kernel.org/sourceware/libabigail/libabigail-2.7.tar.xz"
  sha256 "467c5b91b655fe82c54f92b35a7c2155e0dd9f5f052a4e4e21caf245e092c2ca"
  license "Apache-2.0" => { with: "LLVM-exception" }

  livecheck do
    url "https://mirrors.kernel.org/sourceware/libabigail/"
    regex(/href=.*?libabigail[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_linux:  "7de8d14d00c8437fa48029c8b8ba3a4cdd7e9d7730d30f130b57d98f1ba77f76"
    sha256 x86_64_linux: "c285f7fac9ec608cbde9846f968103f6c8df6a94c786399ee2c66e270d1fb631"
  end

  head do
    url "https://sourceware.org/git/libabigail.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "elfutils"
  depends_on "libxml2"
  depends_on :linux
  depends_on "xxhash"
  depends_on "xz"

  def install
    system "autoreconf", "--force", "--install", "--verbose" if build.head?
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    assert_match "<dependency name='libc.so.6'/>", shell_output("#{bin}/abilint #{test_fixtures("elf/hello")}")
  end
end
