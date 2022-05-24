class Libmobi < Formula
  desc "C library for handling Kindle (MOBI) formats of ebook documents"
  homepage "https://github.com/bfabiszewski/libmobi"
  url "https://github.com/bfabiszewski/libmobi/releases/download/v0.10/libmobi-0.10.tar.gz"
  sha256 "5d6783259f89d33c0e0d176e33854ab9931088b87b6a00bfe882ba07747d0e68"
  license "LGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "b64a189baa7ffa21cd5e0b21f3e49ff3c396024e8ab3e9b780f5a313667a9423"
    sha256 cellar: :any,                 arm64_big_sur:  "920a3edd8de815fa9fe96bf3bc0e07913aea92c80089e9cc8891db38bfd4c7e3"
    sha256 cellar: :any,                 monterey:       "857eb9c7237663b10a91e185f8743ebf81c7d544bf9b10158e6d6b8a7e84f1bb"
    sha256 cellar: :any,                 big_sur:        "acdf11b917bca3413222f44c0d52b488d47870486d880aba63ebdd22ba4aaf9c"
    sha256 cellar: :any,                 catalina:       "eef537a7a5fcd5e757eb985c04d7c738028cf761a30e8462267cbf71b7b4de46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0de00065590b95dfacd672a3fb03d18844e31fc7b453c642cc35f3c76f007e1c"
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
