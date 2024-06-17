class Libabigail < Formula
  desc "ABI Generic Analysis and Instrumentation Library"
  homepage "https://sourceware.org/libabigail/"
  url "https://mirrors.kernel.org/sourceware/libabigail/libabigail-2.5.tar.xz"
  sha256 "7cfc4e9b00ae38d87fb0c63beabb32b9cbf9ce410e52ceeb5ad5b3c5beb111f3"
  license "Apache-2.0" => { with: "LLVM-exception" }

  bottle do
    sha256 x86_64_linux: "290aa7b00f998aee8c38adee01016462fd4f13151915ec15078bc0b4eaf94e3b"
  end

  head do
    url "https://sourceware.org/git/libabigail.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "elfutils"
  depends_on "libxml2"
  depends_on :linux

  def install
    system "autoreconf", "--force", "--install", "--verbose" if build.head?
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make", "install"
  end

  test do
    assert_match "<dependency name='libc.so.6'/>", shell_output("#{bin}/abilint #{test_fixtures("elf/hello")}")
  end
end
