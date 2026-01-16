class Libint < Formula
  desc "Library for computing electron repulsion integrals efficiently"
  homepage "https://github.com/evaleev/libint"
  url "https://github.com/evaleev/libint/archive/refs/tags/v2.12.0.tar.gz"
  sha256 "732988a1ea95eb4eae91bcb2b2a718d95dc5caca41533746fc4111532d55ae74"
  license all_of: ["GPL-3.0-or-later", "LGPL-3.0-or-later"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "50a2ca6ce8e4e38f6af74eadd1016ccf6a5e3ab582f07f880e1b35165b95fb4c"
    sha256 cellar: :any,                 arm64_sequoia: "b66b1bbaa3d92054712f83cbda0942041e950ab63e3bdd310bb576f5ecc8c708"
    sha256 cellar: :any,                 arm64_sonoma:  "c024ee927a2654942604d17a5c0102954e0b975f9331fdadddcfe9cf0abf5ba5"
    sha256 cellar: :any,                 sonoma:        "7da400a5ccb1a38661fb374da8c17faaeaa944959dbcd05f75ad87c0eabba8d3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1719df4e7c6c147daf60e16bd2da82b2ff0c1414d0f21b185557fa6d829c140b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d6b3acd049664939677c56e25b871982d901bc39eb343fa0eb77a31d0cb1c0e"
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
    system ENV.cxx, "-std=c++14", pkgshare/"hartree-fock.cc", "-o", "hartree-fock",
                    "-I#{Formula["eigen"].opt_include}/eigen3",
                    *shell_output("pkgconf --cflags --libs libint2").chomp.split
    system "./hartree-fock", pkgshare/"h2o.xyz"
  end
end
