class Libngspice < Formula
  desc "Spice circuit simulator as shared library"
  homepage "https://ngspice.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/ngspice/ng-spice-rework/42/ngspice-42.tar.gz"
  sha256 "737fe3846ab2333a250dfadf1ed6ebe1860af1d8a5ff5e7803c772cc4256e50a"
  license :cannot_represent

  livecheck do
    formula "ngspice"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1b7f41535b042356748c429ab37a3599bfda3aa8f20aad24460655921c860bca"
    sha256 cellar: :any,                 arm64_ventura:  "994cfb89d39add3d8c3ef0a7d060687b070e36fba4ed8c76eeb56d3a8a110f62"
    sha256 cellar: :any,                 arm64_monterey: "af645ea8cfbc99476161f9cbfa6aa4c2f09cb91e811bab2438db775edbf7de69"
    sha256 cellar: :any,                 sonoma:         "f44a278c06c7e6ea1eea4a77f08c580d46b5d228657c7230b833ba6712bfce7c"
    sha256 cellar: :any,                 ventura:        "872eab8712b544df51cbbbd051037b05612564aa596f68ea0a0b05942e003d30"
    sha256 cellar: :any,                 monterey:       "4008d734e08ececaff89dd41f98895ba3a828e969f0d40f70495e4e11d5ad475"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "76c1ef037bc3fc6ac0cb98fdcf51f45315b2aa9e4718edaee4f91e950ba63889"
  end

  head do
    url "https://git.code.sf.net/p/ngspice/ngspice.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  def install
    system "./autogen.sh" if build.head?

    args = %w[
      --with-ngshared
      --enable-cider
      --enable-xspice
    ]

    system "./configure", *args, *std_configure_args
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
