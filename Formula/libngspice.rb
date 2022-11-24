class Libngspice < Formula
  desc "Spice circuit simulator as shared library"
  homepage "https://ngspice.sourceforge.io/"

  stable do
    url "https://downloads.sourceforge.net/project/ngspice/ng-spice-rework/38/ngspice-38.tar.gz"
    sha256 "2c3e22f6c47b165db241cf355371a0a7558540ab2af3f8b5eedeeb289a317c56"

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
    sha256 cellar: :any,                 arm64_ventura:  "1cc7171cb7d6abde17e2dc04d8a508a53818d643f094216e1952fd3343a703ce"
    sha256 cellar: :any,                 arm64_monterey: "6050333fe137e8588d00246b64d24d09691a6b9d71ad2609493f3a967915ff28"
    sha256 cellar: :any,                 arm64_big_sur:  "f939d3c2d40d5cc3b3264202453dfa8b18c77dfa9d9fa3fbb31205f0aae88ab9"
    sha256 cellar: :any,                 ventura:        "48489a02e4433452e849f84c7dc7b28c34ed43a94e0aad25921afc43f8a07b32"
    sha256 cellar: :any,                 monterey:       "d79b24f3980fecb7b6d1b52529be345edece474121efbc8636da106d6f2a3f86"
    sha256 cellar: :any,                 big_sur:        "61d787f0d5358831155d1c3d1238e7ca00b25a54865496e9190919e8007ff3fa"
    sha256 cellar: :any,                 catalina:       "170c8aae880863774486a8d74b54971a3e78c8fd6e8d151f303fcd89cc728541"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "612e1aa668db6d7f3574c846af876fa6a09e45944e74e6a1213d096ab4dbb3c1"
  end

  head do
    url "https://git.code.sf.net/p/ngspice/ngspice.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "bison" => :build
    depends_on "flex" => :build
    depends_on "libtool" => :build
  end

  def install
    system "./autogen.sh" if build.head?

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-ngshared
      --enable-cider
      --enable-xspice
    ]

    system "./configure", *args
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
