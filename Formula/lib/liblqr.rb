class Liblqr < Formula
  desc "C/C++ seam carving library"
  homepage "https://liblqr.wikidot.com/"
  license "LGPL-3.0-only"
  head "https://github.com/carlobaldassi/liblqr.git", branch: "master"

  stable do
    url "https://github.com/carlobaldassi/liblqr/archive/refs/tags/v0.4.3.tar.gz"
    sha256 "64b0c4ac76d39cca79501b3f53544af3fc5f72b536ac0f28d2928319bfab6def"

    # Fix -flat_namespace being used on Big Sur and later.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/libtool/configure-big_sur.diff"
      sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "c28916c964572477462f09ac74d07c2d633a21e36fae33ff5f63d6902a726613"
    sha256 cellar: :any,                 arm64_sequoia:  "0adf2f9c0c8b464c301df3595f6dab6a86944b1227c7934a2cfdaedce985bc69"
    sha256 cellar: :any,                 arm64_sonoma:   "9ad43c688c7604dc0d12d25a55e5dba657312e6f702c5c7779a529e7b0788c3b"
    sha256 cellar: :any,                 arm64_ventura:  "c93518552d7c18f49dd1fb7e15e23bc36fcd6e43c7a28c82493f552ff4cf4d1a"
    sha256 cellar: :any,                 arm64_monterey: "5a0057c2916952556b4ef88ebdb3facc0dea309da38adb0540ce12d18c08a5cd"
    sha256 cellar: :any,                 sonoma:         "28335247f3e95ffe590d0e7f23ab6ce32bf70963da671336627a024d344cef10"
    sha256 cellar: :any,                 ventura:        "e8644cf78f7d1b496536ccbe8287ce7d67f61a8f53eda230df5e221d004e4ed1"
    sha256 cellar: :any,                 monterey:       "f39b2894ef45355efebbcb7a8277892a1d71a00caa1309ad11caa2d5a97d0426"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "d2b6dff54f55b70b04004cf3bb64045a3b455cd9c9c12bf068c3ebc89ec079f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "df9a20d9afa1541e259edeadd06e3ec8501a9a5b75a5a973e61f321521c37c80"
  end

  depends_on "pkgconf" => :build
  depends_on "glib"

  on_macos do
    depends_on "gettext"
  end

  def install
    system "./configure", "--enable-install-man", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <lqr.h>

      int main() {
        guchar* buffer = calloc(1, sizeof(guchar));

        LqrCarver *carver = lqr_carver_new(buffer, 1, 1, 1);
        if (carver == NULL) return 1;

        lqr_carver_destroy(carver);

        return 0;
      }
    C

    system ENV.cc, "test.c", "-o", "test",
                   "-I#{include}/lqr-1",
                   "-I#{Formula["glib"].opt_include}/glib-2.0",
                   "-I#{Formula["glib"].opt_lib}/glib-2.0/include",
                   "-L#{lib}", "-llqr-1"
    system "./test"
  end
end
