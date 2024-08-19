class Qd < Formula
  desc "C++/Fortran-90 double-double and quad-double package"
  homepage "https://www.davidhbailey.com/dhbsoftware/"
  url "https://www.davidhbailey.com/dhbsoftware/qd-2.3.24.tar.gz"
  sha256 "ad6738e8330928308e10346ff7fd357ed17386408f8fb7a23704cd6f5d52a6c8"
  license "BSD-3-Clause-LBNL"

  livecheck do
    url :homepage
    regex(/href=.*?qd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2d6c0fe69adbd654ff4c13130bce14f46e7fdb3d594b260c7236b32a3bc55a7c"
    sha256 cellar: :any,                 arm64_ventura:  "ce4f6ee31dd29ec69e078441f3aba096597de505b0b0098fccb8cb2a6a0edeb8"
    sha256 cellar: :any,                 arm64_monterey: "a77fe42799177e1e4eb2ab359107d450cf3d9cff86f00ddc1bae02330a2e2962"
    sha256 cellar: :any,                 sonoma:         "2a13b392dc4c3b7ebe4d016839378fa40f91c6329e883ca291e4de2b8b8234e0"
    sha256 cellar: :any,                 ventura:        "c1b6d2b69e6105e815ea8e097483db818ca57de111e79890b01254f807094f04"
    sha256 cellar: :any,                 monterey:       "4153abaea2631b5f77092cdc3916e76e5b612306b5439e8b7ade5c7ed086327f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2849d06e8b854584a38e5ace7959467baa93d2bd1816b13b031f25bb97b2b4dd"
  end

  depends_on "gcc" # for gfortran

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--enable-shared",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/qd-config --configure-args")
  end
end
