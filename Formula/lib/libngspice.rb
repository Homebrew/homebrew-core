class Libngspice < Formula
  desc "Spice circuit simulator as shared library"
  homepage "https://ngspice.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/ngspice/ng-spice-rework/45.2/ngspice-45.2.tar.gz"
  sha256 "ba8345f4c3774714c10f33d7da850d361cec7d14b3a295d0dc9fd96f7423812d"
  license :cannot_represent
  head "https://git.code.sf.net/p/ngspice/ngspice.git", branch: "master"

  livecheck do
    formula "ngspice"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2a4dcbf59d1e5085966adc793687cec6f25336620cd8e52cbced2fc54d5db9d2"
    sha256 cellar: :any,                 arm64_sequoia: "e0a459c7db04f315322f670d4a3303061b5ec63c0cc633aa8fe00f14b0b27eea"
    sha256 cellar: :any,                 arm64_sonoma:  "7b6aab8c0313bb29e1b5343e344f018c3732df5dd16f6ab3b385a60c5301b337"
    sha256 cellar: :any,                 arm64_ventura: "496ac4b64b5ff3c83663d21ae324946e75040a8633f8dc863ee9335adc4502d6"
    sha256 cellar: :any,                 sonoma:        "a3e8c9a2ea5325ff2fb4ef589cce8626f9acfde4a7ed4a74d8d837a80206c3ab"
    sha256 cellar: :any,                 ventura:       "51dc5e48e6dfe8c49c1d88fcbf96d6161f6505d7389f41f54a2cc936d23baeb4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c665af568cd43268f8a6172f1182854442e2dbb2abc6a82488c8da9905e2c1c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b79dc67a685bb6834bee08caf8b1c68d9a06ab95802ef9df0592b48291f1fe6"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  def install
    odie "check if autoreconf line can be removed" if version > "45.2"
    # regenerate since the files were generated using automake 1.16
    system "autoreconf", "--install", "--force", "--verbose"

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
