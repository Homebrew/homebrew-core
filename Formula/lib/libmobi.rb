class Libmobi < Formula
  desc "C library for handling Kindle (MOBI) formats of ebook documents"
  homepage "https://github.com/bfabiszewski/libmobi"
  url "https://github.com/bfabiszewski/libmobi/releases/download/v0.12/libmobi-0.12.tar.gz"
  sha256 "9a6fb2c56b916f8fa8b15e0c71008d908109508c944ea1d297881d4e277bf7e7"
  license "LGPL-3.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "15132d90bd4d7bee048fa33193aec9375cfddda3219f7d6f9cbcadad655e2e6d"
    sha256 cellar: :any,                 arm64_sequoia: "39ee04b0a5a0be276b28b90f97dca5324ca331cb73f4da35631b47b321448972"
    sha256 cellar: :any,                 arm64_sonoma:  "dd23aee2c80c8abae72694b9a67bb29838794a54278c1f5d4a924704116bdb61"
    sha256 cellar: :any,                 sonoma:        "604397f80c682a2f0cb4e0247cf254a5ba7c8d69a131081fd99abac641b9e3a2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a542a91a7c394a9d1b44f7bb2b3d5221a4d0082e70517883759b238a10bd25cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b740ba63e81ce6d375886cd8cae28a16acedbd25051004f236ff259c991fe330"
  end

  uses_from_macos "libxml2"
  uses_from_macos "zlib"

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
