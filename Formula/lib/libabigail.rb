class Libabigail < Formula
  desc "ABI Generic Analysis and Instrumentation Library"
  homepage "https://sourceware.org/libabigail/"
  url "https://mirrors.kernel.org/sourceware/libabigail/libabigail-2.9.tar.xz"
  sha256 "b4b86baa3105a28ada25091f1ef0535e7a60616d3d5d4cb1ee2aceaba341d738"
  license "Apache-2.0" => { with: "LLVM-exception" }

  livecheck do
    url "https://mirrors.kernel.org/sourceware/libabigail/"
    regex(/href=.*?libabigail[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_linux:  "f16a811a8930cd335c913c9c7757b68d12b5e21d246eac6f0bc5e8991b9c2a63"
    sha256 x86_64_linux: "7dcc8580840ca683c97b467b61d78ef524c31bbb85029a0e3ffc65c2ec525d72"
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
