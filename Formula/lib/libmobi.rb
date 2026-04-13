class Libmobi < Formula
  desc "C library for handling Kindle (MOBI) formats of ebook documents"
  homepage "https://github.com/bfabiszewski/libmobi"
  url "https://github.com/bfabiszewski/libmobi/releases/download/v0.12/libmobi-0.12.tar.gz"
  sha256 "9a6fb2c56b916f8fa8b15e0c71008d908109508c944ea1d297881d4e277bf7e7"
  license "LGPL-3.0-or-later"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "2c692dcb58d257bfaeb352c4bf6240d7479ca2fe5ebc2064b2ca1b4d2466e592"
    sha256 cellar: :any,                 arm64_sequoia: "0d79535ee222bee7cf090b9f36217fa2b88d92ac96c72665e6f2012e562c4c59"
    sha256 cellar: :any,                 arm64_sonoma:  "811f7c109ae3f3b535c51d381ae0dfb7703a8515ed207fb847df6036c4893d23"
    sha256 cellar: :any,                 sonoma:        "227cc265d99edfe9ffe1526ad3a64b774cdcf75afc42546f472af1fe5563d209"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f2a3bc46369f896c9b4211d84bf368829ca6d3bb98411c2675c0696cbf4e9f7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "189a28e29037f0925fa470adbcb876f4e07a16c09731ecd9c2ad2db060b49597"
  end

  uses_from_macos "libxml2"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <mobi.h>
      int main() {
        MOBIData *m = mobi_init();
        if (m == NULL) {
          return 1;
        }
        mobi_free(m);
        return 0;
      }
    CPP
    system ENV.cxx, "test.cpp", "-I#{include}", "-L#{lib}", "-lmobi", "-o", "test"
    system "./test"
  end
end
