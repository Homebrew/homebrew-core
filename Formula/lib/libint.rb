class Libint < Formula
  desc "Library for computing electron repulsion integrals efficiently"
  homepage "https://github.com/evaleev/libint"
  url "https://github.com/evaleev/libint/archive/refs/tags/v2.11.1.tar.gz"
  sha256 "58ab0f893d94cbed3ab35a6c26ec5e4d8541c59889407a6d30c50b8ea415bdf3"
  license all_of: ["GPL-3.0-or-later", "LGPL-3.0-or-later"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8ba0d94d0c2d08ae7f060c780b17138ccc9768a4085d70a9ebc07092bca0dbaf"
    sha256 cellar: :any,                 arm64_sonoma:  "b4ed148dadc7cbef2fdba90c530aaa81fbbbc10b458a01548ed837667941f1d7"
    sha256 cellar: :any,                 arm64_ventura: "321b83111abb704f45530c5e2431543b202cef7b79f149d8a18d9d92ffbc95c7"
    sha256 cellar: :any,                 sonoma:        "496e3e04c6113298f83adb651e18899fcebb7272fa90bfcd263e84549435989e"
    sha256 cellar: :any,                 ventura:       "4ca95b782163ae0ae71b84f74c2a828b6e9717909ae8ab3e85c7f948bd7dfca4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "660f1718e9e4490c778a99ac2f2a2ffe1e7ea97b911ecec248ddceb43ab44941"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "45e54a1351ab5f13cc1a3cc83d8ba7fbeb8812c753f44cc5c0fda0e57e7f5ba0"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "boost"
  depends_on "eigen"
  depends_on "mpfr"

  def install
    system "glibtoolize", "--install", "--force"
    system "./autogen.sh"
    system "./configure", "--enable-shared", "--disable-static", *std_configure_args
    system "make"
    system "make", "install"
    pkgshare.install "tests/hartree-fock/hartree-fock.cc"
    pkgshare.install "tests/hartree-fock/h2o.xyz"
  end

  test do
    system ENV.cxx, "-std=c++11", pkgshare/"hartree-fock.cc", "-o", "hartree-fock",
                    "-I#{Formula["eigen"].opt_include}/eigen3",
                    *shell_output("pkgconf --cflags --libs libint2").chomp.split
    system "./hartree-fock", pkgshare/"h2o.xyz"
  end
end
