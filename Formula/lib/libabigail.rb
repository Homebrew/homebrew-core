class Libabigail < Formula
  desc "ABI Generic Analysis and Instrumentation Library"
  homepage "https://sourceware.org/libabigail/"
  url "https://mirrors.kernel.org/sourceware/libabigail/libabigail-2.6.tar.xz"
  sha256 "3bfa8ba753ff27722baa7f73b15a475f8a4599355e47439108423d1912bb5469"
  license "Apache-2.0" => { with: "LLVM-exception" }

  bottle do
    sha256 x86_64_linux: "39bfad0c9e5cbb11821b3ee99ae6e599d84a20343eb8ae49294c88d2514da12a"
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
  depends_on "xxhash"

  def install
    system "autoreconf", "--force", "--install", "--verbose" if build.head?
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make", "install"
  end

  test do
    assert_match "<dependency name='libc.so.6'/>", shell_output("#{bin}/abilint #{test_fixtures("elf/hello")}")
  end
end
