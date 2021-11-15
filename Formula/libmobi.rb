class Libmobi < Formula
  desc "C library for handling Kindle (MOBI) formats of ebook documents"
  homepage "https://github.com/bfabiszewski/libmobi"
  url "https://github.com/bfabiszewski/libmobi/releases/download/v0.9/libmobi-0.9.tar.gz"
  sha256 "136f81451e51486e57ec2afe5a64e56d6604cf99ee4a2d01fba288ab4dce161f"
  license "LGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "4f1747ba00caba7df453292c5443a646d87951b6d1007ee8cf0a54ba52701f10"
    sha256 cellar: :any,                 arm64_big_sur:  "67babfb4198ee17ae835b379b1cdd9e30b079b1cb485d4670e7c497f6f627f1c"
    sha256 cellar: :any,                 monterey:       "30fb67be80e69ae23b18b766105274e7280352ea6d33ed9b7b65ea343f15f936"
    sha256 cellar: :any,                 big_sur:        "d32823a5428cca4c7d81be853e1733a2df36da67f93bf0ba4a969174d5b1ab72"
    sha256 cellar: :any,                 catalina:       "7206d2e0b13453eeabe871518bc9961ad95e9bc0f2c223e31ec7ff134db64d6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3cb122be57102c33446b67c9481926445e996c5b1711588a963268646ad70f9e"
  end

  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <mobi.h>
      int main() {
        MOBIData *m = mobi_init();
        if (m == NULL) {
          return 1;
        }
        mobi_free(m);
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-I#{include}", "-L#{lib}", "-lmobi", "-o", "test"
    system "./test"
  end
end
