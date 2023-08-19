class Liblqr < Formula
  desc "C/C++ seam carving library"
  homepage "https://liblqr.wikidot.com/"
  license "LGPL-3.0-only"
  revision 1
  head "https://github.com/carlobaldassi/liblqr.git", branch: "master"

  stable do
    url "https://github.com/carlobaldassi/liblqr/archive/v0.4.2.tar.gz"
    sha256 "1019a2d91f3935f1f817eb204a51ec977a060d39704c6dafa183b110fd6280b0"

    # Fix -flat_namespace being used on Big Sur and later.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-pre-0.4.2.418-big_sur.diff"
      sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
    end
  end

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_ventura:  "3a4c0255039976ec4a2e0dbfc88a12a1383003825d6d9d9ad5403e5dd9c2d56d"
    sha256 cellar: :any,                 arm64_monterey: "fb32db288c0fd8f9c45f1de75896b354542ef6a7f5cc0a24282c3b1766acfae5"
    sha256 cellar: :any,                 arm64_big_sur:  "7e7dcc285c326d8a9a0a79c63fd7b1664be895531ff4f6457a77153605d6897e"
    sha256 cellar: :any,                 ventura:        "031968398921ebf58e91587cc82316195e580d5a7167a6cac11baf21c2f49441"
    sha256 cellar: :any,                 monterey:       "7a39de7c269870d6ce8978eaa899aa378c9a02fb2e4c3ef8bdd22bb08a050f58"
    sha256 cellar: :any,                 big_sur:        "a0e88a1ce13ce43c2bf0fb0e4bdd7e9d33a367245d2ebf0f0d8dfe283666be7c"
    sha256 cellar: :any,                 catalina:       "cd43ea7ec18f81334585dade45d03d1bafe2039c1308d41d7049eafdad5059b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "11cfab7a9ac36b9ca2d2f3984ed8c40ee4af55bc8a473ae27d5abba9e4892934"
  end

  depends_on "pkg-config" => :build
  depends_on "glib"

  def install
    system "./configure", *std_configure_args, "--enable-install-man"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <lqr.h>
      int main() {
        guchar* buffer = calloc(1, sizeof(guchar));

        LqrCarver *carver = lqr_carver_new(buffer, 1, 1, 1);
        if (carver == NULL) return 1;

        lqr_carver_destroy(carver);

        return 0;
      }
    EOS

    system ENV.cc, "test.c",
                   "-I#{include}/lqr-1",
                   "-I#{Formula["glib"].opt_include}/glib-2.0",
                   "-I#{Formula["glib"].opt_lib}/glib-2.0/include",
                   "-L#{lib}", "-llqr-1"
    system "./a.out"
  end
end
