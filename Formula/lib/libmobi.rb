class Libmobi < Formula
  desc "C library for handling Kindle (MOBI) formats of ebook documents"
  homepage "https://github.com/bfabiszewski/libmobi"
  url "https://github.com/bfabiszewski/libmobi/releases/download/v0.12/libmobi-0.12.tar.gz"
  sha256 "9a6fb2c56b916f8fa8b15e0c71008d908109508c944ea1d297881d4e277bf7e7"
  license "LGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "208651021ee3e089ea2c3665b2f94f9acc0ad7401205f9177d82381f2da261b5"
    sha256 cellar: :any,                 arm64_sonoma:   "d1fe8e0413649a0a838d650e614ef07010aa121e1ab3a2b360d8ba6da1124a77"
    sha256 cellar: :any,                 arm64_ventura:  "1f4ea76703406a4f5453ac1767100a8198d6bf14782c1a6a862fcb3e2dd5d908"
    sha256 cellar: :any,                 arm64_monterey: "4745216331bec2106dad3b68997ff46888b15ca74a19f4e6aafc510ed16daa26"
    sha256 cellar: :any,                 sonoma:         "d510c86ba6f58c1835f3b4721986058711d2db5d94c9d6c9afc1d08f6f7a5316"
    sha256 cellar: :any,                 ventura:        "5182d5625306772b104ee2fa38105e399c82bc33b25c01934f5722bfefddd177"
    sha256 cellar: :any,                 monterey:       "ac43b774943fed966a0698c82cf05ec9bd8f020380ac12810cb60613d7d8923b"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "633df7f3e0d7c1287ea87f79b6ae22f088a9f87fafb9ad825f56e619ba72b8ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "380132da0b9faf43d841d6eeaeafa37cfbf1381d2a66549a105c44808022fcc8"
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
