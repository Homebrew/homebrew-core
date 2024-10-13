class Libngspice < Formula
  desc "Spice circuit simulator as shared library"
  homepage "https://ngspice.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/ngspice/ng-spice-rework/43/ngspice-43.tar.gz"
  sha256 "14dd6a6f08531f2051c13ae63790a45708bd43f3e77886a6a84898c297b13699"
  license :cannot_represent

  livecheck do
    formula "ngspice"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "58d94f62b040d2233be90e43c2c245577b58a7ad26e3061f6c543cc836c7679c"
    sha256 cellar: :any,                 arm64_sonoma:   "08d34caae24bf2e5922e21bf6cc069fc0104d6a91bec5df245b2c10eda161ea5"
    sha256 cellar: :any,                 arm64_ventura:  "655107924c134dba8f4d014157a0dcd96a540e477cde0daf572e89606808ee5c"
    sha256 cellar: :any,                 arm64_monterey: "796bc6f9713683e875d6f8ddf1c34b961269791fa8b3543a3056e49c1b05d819"
    sha256 cellar: :any,                 sonoma:         "e0a25a456c4fbe11c600fa59edd984502cb26938da52b8a8f94bef8f139e2fbb"
    sha256 cellar: :any,                 ventura:        "e82c34fa66368d3ad017e5fcb55a38aec99053a4b48181e5ef836c6a1672ac55"
    sha256 cellar: :any,                 monterey:       "d5d137b9a286bef3d5ce8f9fa82c2886d2a68cc491ed6ddd39116c47116c8a17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b2f0e80dc6c18dade4045ecca05f3e2824d1eb6c220c26b055272ce9bcd2f75d"
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
      --disable-openmp
    ]

    system "./configure", *args, *std_configure_args
    system "make", "install"

    # remove script files
    rm_r(Dir[share/"ngspice/scripts"])
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
