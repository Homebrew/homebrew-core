class Libngspice < Formula
  desc "Spice circuit simulator as shared library"
  homepage "https://ngspice.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/ngspice/ng-spice-rework/45/ngspice-45.tar.gz"
  sha256 "f1aad8abac2828a7b71da66411de8e406524e75f3066e46755439c490442d734"
  license :cannot_represent

  livecheck do
    formula "ngspice"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8640f2c59198f340d8a500c68c42fa2c9a4a52d2a01fdf4ed2f5029e21348295"
    sha256 cellar: :any,                 arm64_sonoma:  "30852e6c8a36510ea1d2dd62125e67b04643b7f77632f082da72c92f56233813"
    sha256 cellar: :any,                 arm64_ventura: "ed7ed1371490ca0220161cae6ecf9bcc572a6f1f33657a39d206a110b1e115d6"
    sha256 cellar: :any,                 sonoma:        "9841e745b6b916b089c4816d1073a23e9ba52258d7a9b6ed79a2812dbc7bcf13"
    sha256 cellar: :any,                 ventura:       "abd210c4683adc038574cc03e8c37859af1bc678ae5291614a7a99f7346ce78b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a6559b9a44837e4319d77d3489072e6c3ffa085a44bda2764089ab0ddbf1989a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b380afa18369e0f571e37ff8812ba0946483d145de2f2db08a0f1d996885a52"
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
