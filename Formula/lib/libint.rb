class Libint < Formula
  desc "Library for computing electron repulsion integrals efficiently"
  homepage "https://github.com/evaleev/libint"
  url "https://github.com/evaleev/libint/archive/refs/tags/v2.9.0.tar.gz"
  sha256 "4929b2f2d3e53479270be052e366e8c70fa154a7f309e5c2c23b7d394159687d"
  license all_of: ["GPL-3.0-or-later", "LGPL-3.0-or-later"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "6519df8379bd847957c081d2dacdffb95ef347a66f2838d714e37428f1c77f41"
    sha256 cellar: :any,                 arm64_sonoma:   "8b9c9799736c041a79eabe1e5c0ff219572ad2c96dfaca6f325ac947ff76fff8"
    sha256 cellar: :any,                 arm64_ventura:  "5e6451aca0b1d84433f2b81c9eec8e4ab2440d2894018a70950c2eec74ef84b4"
    sha256 cellar: :any,                 arm64_monterey: "67e3ef568131a5a97526fb5481980cfb615826fff081db883abc59a32b622b80"
    sha256 cellar: :any,                 sonoma:         "3e2d4930bd84325000adab1448506c1f563f76b871dec92799b131bbd57a8b1e"
    sha256 cellar: :any,                 ventura:        "c534506c058ec810432b988c53503c794e4d3deebcb6e5f08fb1569ccdb92bdf"
    sha256 cellar: :any,                 monterey:       "90bc5d348cfd819e75af619d002d353399f9389a65f06955c2085fa7874766ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d2f489f45da4c7b33eb0fb5f0827045ae9d14f2ede7011678d70bf8128d75bcd"
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
