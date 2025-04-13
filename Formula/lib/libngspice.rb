class Libngspice < Formula
  desc "Spice circuit simulator as shared library"
  homepage "https://ngspice.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/ngspice/ng-spice-rework/44.2/ngspice-44.2.tar.gz"
  sha256 "e7dadfb7bd5474fd22409c1e5a67acdec19f77e597df68e17c5549bc1390d7fd"
  license :cannot_represent

  livecheck do
    formula "ngspice"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5a4bc846e0ffc9fa23d9c15509b5cf041de5c5dadcf476ffb167302b84f5bf75"
    sha256 cellar: :any,                 arm64_sonoma:  "be3d94c10d2554bcc43c71f7e6061005280929a551a6c96e3735dcd6060391d5"
    sha256 cellar: :any,                 arm64_ventura: "63fbc552611b183799b6a0837db9c9f06c0d4f215ccfbfb0f6bc699343931804"
    sha256 cellar: :any,                 sonoma:        "27eb9642d676e757187eff463ea80dcd2c1bbecb0da4558f4d7c98792e8199b5"
    sha256 cellar: :any,                 ventura:       "9c9b8a825a59abf6e61518cedf952a3bb62929fa175ac23898603a3a7618c063"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "22e30c641b1925c47f728f45f2fedeb7eede9447fb06f6449acb2cf25c24e6c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "151d4740e5f524966fa99db6635c338e5a70428b45b098c61ca23d38567fdfef"
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
    (testpath/"test.cpp").write <<~CPP
      #include <cstdlib>
      #include <ngspice/sharedspice.h>
      int ng_exit(int status, bool immediate, bool quitexit, int ident, void *userdata) {
        return status;
      }
      int main() {
        return ngSpice_Init(NULL, NULL, ng_exit, NULL, NULL, NULL, NULL);
      }
    CPP
    system ENV.cc, "test.cpp", "-I#{include}", "-L#{lib}", "-lngspice", "-o", "test"
    system "./test"
  end
end
