class Libngspice < Formula
  desc "Spice circuit simulator as shared library"
  homepage "https://ngspice.sourceforge.io/"
  license :cannot_represent

  stable do
    url "https://downloads.sourceforge.net/project/ngspice/ng-spice-rework/39/ngspice-39.tar.gz"
    sha256 "b89c6bbce6e82ca9370b7f5584c9a608b625a7ed25e754758c378a6fb7107925"

    # Fix -flat_namespace being used on Big Sur and later.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
      sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
    end
  end

  livecheck do
    formula "ngspice"
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "6bbda9520f8ce8a119d8a57d818db8f047e3b5fd3c38c64581ec5bd49e79b7a0"
    sha256 cellar: :any,                 arm64_monterey: "6c3f6c0ee1338d7d3cc03a1502dfd6e91c733a4ebd46b785b9c83de54dc9f7f8"
    sha256 cellar: :any,                 arm64_big_sur:  "f9579831501b287b0d49fc4091287a0d4f6699d9df593a67bf188b7c0931f1bb"
    sha256 cellar: :any,                 ventura:        "ab0d77698f8a02969ea20dc085b67d497cd614d487b32e4a5e61bdc31a5e06ec"
    sha256 cellar: :any,                 monterey:       "efdea06b48e076ab6740bd56e9a1ff5a9a4d29e923f99671a50063d4862b3a24"
    sha256 cellar: :any,                 big_sur:        "c278dab4b9ed35368e0058b85625619cf2eb7bcab81b3b7818cfcf42d70b4d72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f874a73d87f835f22e81e7baa4aa057bd74f146898132f9c084f1e4455881f9d"
  end

  head do
    url "https://git.code.sf.net/p/ngspice/ngspice.git", branch: "master"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "bison" => :build
  depends_on "flex" => :build
  depends_on "libtool" => :build

  def install
    system "./autogen.sh"

    args = %w[
      --with-ngshared
      --enable-cider
      --enable-xspice
    ]

    system "./configure", *std_configure_args, *args
    system "make", "install"

    # remove script files
    rm_rf Dir[share/"ngspice/scripts"]
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <cstdlib>
      #include <ngspice/sharedspice.h>
      int ng_exit(int status, bool immediate, bool quitexit, int ident, void *userdata) {
        return status;
      }
      int main() {
        return ngSpice_Init(NULL, NULL, ng_exit, NULL, NULL, NULL, NULL);
      }
    EOS
    system ENV.cc, "test.cpp", "-I#{include}", "-L#{lib}", "-lngspice", "-o", "test"
    system "./test"
  end
end
