class Libabigail < Formula
  desc "ABI Generic Analysis and Instrumentation Library"
  homepage "https://sourceware.org/libabigail/"
  url "https://mirrors.kernel.org/sourceware/libabigail/libabigail-2.8.tar.xz"
  sha256 "0f52b1ab7997ee2f7895afb427f24126281f66a4756ba2c62bce1a17b546e153"
  license "Apache-2.0" => { with: "LLVM-exception" }
  revision 1

  livecheck do
    url "https://mirrors.kernel.org/sourceware/libabigail/"
    regex(/href=.*?libabigail[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_linux:  "6fbb19ac846182757c8efbf2c16b50453e0d4c0d1db712e668187b26d5efe7b0"
    sha256 x86_64_linux: "d4528ffc550deef135b5002e9aa3becc57096c9cbf7ead47eabe20a3a9baf5ca"
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
