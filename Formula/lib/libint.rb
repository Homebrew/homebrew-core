class Libint < Formula
  desc "Library for computing electron repulsion integrals efficiently"
  homepage "https://github.com/evaleev/libint"
  url "https://github.com/evaleev/libint/archive/refs/tags/v2.11.0.tar.gz"
  sha256 "4d2c83995f7b9fc19c10b4f5f3973659d6b8054cadc1a9746d3e072a5fb568ae"
  license all_of: ["GPL-3.0-or-later", "LGPL-3.0-or-later"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "dbc9c7c6732e595b15faaf09553ad44c7b92a8c3191aaad777e0c58aeb8b91c3"
    sha256 cellar: :any,                 arm64_sonoma:  "8d40cbbced1a5e44c0db93882531c1784cb4093cf0d3e228ae7333e10058de3f"
    sha256 cellar: :any,                 arm64_ventura: "346966aba2c9a1b3b9c689b4557f6118c22c95109a0003ef2e90dbe30faa2129"
    sha256 cellar: :any,                 sonoma:        "538eeea8d2edd4a3c57607b50a0de3c85383ac1ff811ccfa6eca72d6a6f13daf"
    sha256 cellar: :any,                 ventura:       "5156d657bf5a7f5fffe2f7c22a3907abb3a1c3ba7708c1c4768a7cb455e4c6e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1b41700a38957a6ee2c4cfa18548827e548d0b98808822d02e59598d954a1e16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "125d80de57d287b1ebe9d6765ffaaeaffbdea1cf04a8fa64e4326fbb01ffe907"
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
