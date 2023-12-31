class Libint < Formula
  desc "Library for computing electron repulsion integrals efficiently"
  homepage "https://github.com/evaleev/libint"
  url "https://github.com/evaleev/libint/archive/refs/tags/v2.8.1.tar.gz"
  sha256 "54ae9c55f03f1989ee4792ab1ec24eda8ac88126f9c11f3723ed76a3275b3e24"
  license all_of: ["GPL-3.0-or-later", "LGPL-3.0-or-later"]

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b4a4fd1ff492246109a73fed6aa8ce49c8e74aaa670586064d8ef7c8af58142b"
    sha256 cellar: :any,                 arm64_ventura:  "33753446e48218f652678b8f6696becd949c6d5e2f56de11a3f246cdba4d826b"
    sha256 cellar: :any,                 arm64_monterey: "3a76c0d6b3a856436f193409a81998affb8a9de85e8f48c618e8d58651175100"
    sha256 cellar: :any,                 sonoma:         "6792ca91d70a9f5d5b9f3c84245df31dd8f11c5ad148daabbcd890d0b34d27bc"
    sha256 cellar: :any,                 ventura:        "97a3bce087c922704566112b48924dc9e06afaf0403a490292747fe17ee447f5"
    sha256 cellar: :any,                 monterey:       "bf48d6080463ef5b2baa9ec376cd96e4a31dfc1f5ecf68565bf0a44adcb845c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "789c6ebcf1a234d04b73ced32dc9e380dff5f9e48ecd6ff5b7f593f0816786b9"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => [:build, :test]
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
    system ENV.cxx, "-std=c++11", pkgshare/"hartree-fock.cc",
      *shell_output("pkg-config --cflags --libs libint2").chomp.split,
      "-I#{Formula["eigen"].opt_include}/eigen3",
      "-o", "hartree-fock"
    system "./hartree-fock", pkgshare/"h2o.xyz"
  end
end
