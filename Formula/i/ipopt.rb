class Ipopt < Formula
  desc "Interior point optimizer"
  homepage "https://coin-or.github.io/Ipopt/"
  url "https://github.com/coin-or/Ipopt/archive/refs/tags/releases/3.14.14.tar.gz"
  sha256 "264d2d3291cd1cd2d0fa0ad583e0a18199e3b1378c3cb015b6c5600083f1e036"
  license "EPL-2.0"
  head "https://github.com/coin-or/Ipopt.git", branch: "stable/3.14"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "392a3455a4d487fc3f39633680c0924bcb287891e13dad08c9a963317472f32b"
    sha256 cellar: :any,                 arm64_ventura:  "6f26dedbbe1406b4e2b305eca2c7785df2c6489dd14bbd3299f971006c7db963"
    sha256 cellar: :any,                 arm64_monterey: "6ee09f1b5d0998bea471d81652fd65865f2176005acabdb3300c52b46fe4fa06"
    sha256 cellar: :any,                 sonoma:         "606da12775b919ab5ab762a51a35a4ad1cb24f47c805930d0e0a55d260e76ffc"
    sha256 cellar: :any,                 ventura:        "47cfb0705651d5e6d1fa1a6099f48e85053968b185cd4e146cced245b2df2faf"
    sha256 cellar: :any,                 monterey:       "5aa16d5ef3b9417cbd1e6aff1b230c36880a90d7d62da11291df27235d25408a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "db820ab3f8e5f6806c06f20cff8d161d27228420256491102185a907102cfc9c"
  end

  depends_on "openjdk" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "ampl-mp"
  depends_on "gcc" # for gfortran
  depends_on "mumps"
  depends_on "openblas"

  resource "test" do
    url "https://github.com/coin-or/Ipopt/archive/refs/tags/releases/3.14.14.tar.gz"
    sha256 "264d2d3291cd1cd2d0fa0ad583e0a18199e3b1378c3cb015b6c5600083f1e036"
  end

  def install
    ENV.delete("MPICC")
    ENV.delete("MPICXX")
    ENV.delete("MPIFC")

    args = [
      "--disable-debug",
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--enable-shared",
      "--prefix=#{prefix}",
      "--with-blas=-L#{Formula["openblas"].opt_lib} -lopenblas",
      "--with-mumps-cflags=-I#{Formula["mumps"].opt_include}",
      "--with-mumps-lflags=-L#{lib} -ldmumps -lmpiseq -lmumps_common -lopenblas -lpord",
      "--with-asl-cflags=-I#{Formula["ampl-mp"].opt_include}/asl",
      "--with-asl-lflags=-L#{Formula["ampl-mp"].opt_lib} -lasl",
    ]

    system "./configure", *args
    system "make"

    ENV.deparallelize
    system "make", "install"
  end

  test do
    testpath.install resource("test")
    pkg_config_flags = `pkg-config --cflags --libs ipopt`.chomp.split
    system ENV.cxx, "examples/hs071_cpp/hs071_main.cpp", "examples/hs071_cpp/hs071_nlp.cpp", *pkg_config_flags
    system "./a.out"
    system "#{bin}/ipopt", "#{Formula["ampl-mp"].opt_pkgshare}/example/wb"
  end
end
