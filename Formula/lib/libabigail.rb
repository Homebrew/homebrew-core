class Libabigail < Formula
  desc "ABI Generic Analysis and Instrumentation Library"
  homepage "https://sourceware.org/libabigail/"
  url "https://mirrors.kernel.org/sourceware/libabigail/libabigail-2.8.tar.xz"
  sha256 "0f52b1ab7997ee2f7895afb427f24126281f66a4756ba2c62bce1a17b546e153"
  license "Apache-2.0" => { with: "LLVM-exception" }

  livecheck do
    url "https://mirrors.kernel.org/sourceware/libabigail/"
    regex(/href=.*?libabigail[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_linux:  "ea4bb90e1a4f2243dbb3da8b41c639b8f86cf26b31a81a0ed0f78fbd5b2dbfb9"
    sha256 x86_64_linux: "107b3688c8a17ab46cc159f6e28401af834ad1175590d6a57f601e659fe9752d"
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
