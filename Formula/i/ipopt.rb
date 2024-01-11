class Ipopt < Formula
  desc "Interior point optimizer"
  homepage "https://coin-or.github.io/Ipopt/"
  url "https://github.com/coin-or/Ipopt/archive/refs/tags/releases/3.14.13.tar.gz"
  sha256 "2afcb057e7cf8ed7e07f50ee0a4a06d2e4d39e0f964777e9dd55fe56199a5e0a"
  license "EPL-2.0"
  head "https://github.com/coin-or/Ipopt.git", branch: "stable/3.14"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ecca48aaf51c47a158c6017ee1d22ed3f0d4ec81fe8c78728af5e288ac327060"
    sha256 cellar: :any,                 arm64_ventura:  "7c627f71153c1fd4a76f25ceb8dc14bae244c71ac6317210051770e1ecd8d9c2"
    sha256 cellar: :any,                 arm64_monterey: "9c9fea30d937280699587f39e061727e29a2876d3b890c6c9b09b5874fde6cea"
    sha256 cellar: :any,                 sonoma:         "8ba3a9045d04e3cdca14326189f91e45e0e77ec6c410158b6f36acb7f9ad0d34"
    sha256 cellar: :any,                 ventura:        "e760928cd8a983af6704b6bceadac9799f47274a54e63cc4bc08157ca0647ddf"
    sha256 cellar: :any,                 monterey:       "a634277f01acf6d27f418800621101f86eefeeff0b46c67eaf52b431f28fe0e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "afdd91ce638f0af35053e830b24de64a2e09328700d814ab7a90ac0f543f8c41"
  end

  depends_on "openjdk" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "ampl-mp"
  depends_on "gcc" # for gfortran
  depends_on "mumps"
  depends_on "openblas"

  resource "test" do
    url "https://github.com/coin-or/Ipopt/archive/refs/tags/releases/3.14.13.tar.gz"
    sha256 "2afcb057e7cf8ed7e07f50ee0a4a06d2e4d39e0f964777e9dd55fe56199a5e0a"
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
