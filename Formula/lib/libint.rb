class Libint < Formula
  desc "Library for computing electron repulsion integrals efficiently"
  homepage "https://github.com/evaleev/libint"
  url "https://github.com/evaleev/libint/archive/refs/tags/v2.11.2.tar.gz"
  sha256 "f2fba90579d95f535a93decdae98028ef3a982e6570e1547a0916186f51e86f2"
  license all_of: ["GPL-3.0-or-later", "LGPL-3.0-or-later"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7af4dab8242ce8ddd3a69bb78b8ddac45e42533c1ca6214993d4ef1c43fa3e2e"
    sha256 cellar: :any,                 arm64_sequoia: "7a4d7f01be48bc37f6127a9ba3986a48e38a7a770f2e10d5f740e644d725a6a4"
    sha256 cellar: :any,                 arm64_sonoma:  "62a17714752ac307164d3dfb29be32578f548ecd2d88938eac582f42bb5f3595"
    sha256 cellar: :any,                 sonoma:        "e62dfac42c0bceeafa6041d4117d2ac249f381739c7d486b0fa2e7a85fe69374"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a24d4b1a267ace8365de2f8b7f98b200e86403f02f289833cf42429dbdcee262"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2814f8cd9ed88148a055020bb9ecc75a804a7aa184f9ca6423052fc4ba43435c"
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
