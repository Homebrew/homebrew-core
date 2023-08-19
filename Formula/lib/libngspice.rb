class Libngspice < Formula
  desc "Spice circuit simulator as shared library"
  homepage "https://ngspice.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/ngspice/ng-spice-rework/41/ngspice-41.tar.gz"
  sha256 "1ce219395d2f50c33eb223a1403f8318b168f1e6d1015a7db9dbf439408de8c4"
  license :cannot_represent

  livecheck do
    formula "ngspice"
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "35e4991aa14029725d0512964f20bb798de91144d854420b414ec51227a0af00"
    sha256 cellar: :any,                 arm64_monterey: "f0a2be752a5e2a3e1a6804ad6b065be2cfc0698ec25d54c5739955da96619ae9"
    sha256 cellar: :any,                 arm64_big_sur:  "155f952fc22ab43f0442bda6a7fc4a0b3772daad51a92c7235975bc9ecaf0c5b"
    sha256 cellar: :any,                 ventura:        "133060ca3e897fca4a0b43b2b461754b451611eda52ab563ccccbdb47f51d05f"
    sha256 cellar: :any,                 monterey:       "20b974fd43b86bc618e3dc5d45d0c62898c478e05923d79dbd5b30736fd2bd65"
    sha256 cellar: :any,                 big_sur:        "de9bdd19e9de3ddb90798e57c83393a07e5e437970780c9da875057203e34241"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "faa574b5ef1f44ad398276d866a93d83db532b75101f30ceb7a276d9ba9e08a3"
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
