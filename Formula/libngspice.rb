class Libngspice < Formula
  desc "Spice circuit simulator as shared library"
  homepage "https://ngspice.sourceforge.io/"
  license :cannot_represent

  stable do
    url "https://downloads.sourceforge.net/project/ngspice/ng-spice-rework/40/ngspice-40.tar.gz"
    sha256 "e303ca7bc0f594e2d6aa84f68785423e6bf0c8dad009bb20be4d5742588e890d"

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
    sha256 cellar: :any,                 arm64_ventura:  "94c62857772079959572fb5531bfaff1760587ee6ffdeffd347a2e0ae6d0dba3"
    sha256 cellar: :any,                 arm64_monterey: "809effc0b4ace2682dd7a7fdabcbb944a165d186371ce07caf1c9b829a28db7b"
    sha256 cellar: :any,                 arm64_big_sur:  "1a7a9bc7bc98c0f12139ff6b1c2fe17640a80fef7dffb9ecd733083d3ef91c6c"
    sha256 cellar: :any,                 ventura:        "a5ac75e3210913fa6e0fcd797b4e0b4751726a2c135534ed2155aca06bf64e2f"
    sha256 cellar: :any,                 monterey:       "bd9f509b6afc0bbf420425e81ce28f91da99a6eacda3e78f786a29ad60de6808"
    sha256 cellar: :any,                 big_sur:        "ea8c715b7aa3f06b1e00d5737a382850eb478aedd9a1b910b78b343211b83cb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8fc02026eee4e3b859bb0d931915f14b1d4972dc6e472a5bca4d03bfafc841ce"
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
