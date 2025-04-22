class Ns3 < Formula
  include Language::Python::Virtualenv

  desc "Discrete-event network simulator"
  homepage "https://www.nsnam.org/"
  url "https://gitlab.com/nsnam/ns-3-dev/-/archive/ns-3.44/ns-3-dev-ns-3.44.tar.gz"
  sha256 "14539f7e73d54788514597c03f110d2cf9a251386543bd389b28bf9ab122e58e"
  license "GPL-2.0-only"

  bottle do
    sha256                               arm64_sequoia: "1b2401c6ee8a679908199458daddaac700f901aa75b5d3fe27989d98d2629019"
    sha256                               arm64_sonoma:  "b8d7754bc3619c27ded759f220c8f2db346ec7f1756a85360a1517e5e603ddcf"
    sha256                               arm64_ventura: "5213e90d6642839fd03c0dd859be2e840a36463b08a2d8f2c1557d27c38df356"
    sha256                               sonoma:        "c795c64d2bdd26376c506c21511198689d7fb47f853b5320928a26b8c08a43fc"
    sha256                               ventura:       "17c2a8f7c608157f7b227a67c6502f85f13c13aa1c2afb874bdc61ee522b66d0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "516bebae3e854dc0359693bfe5dad2f2561cd32dd222a67322ed7cc78484e1b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7826cdd902f244fd4352db46004e28c895616af90bc0e25d78671e7a4e46eb92"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "gsl"
  depends_on "open-mpi"

  uses_from_macos "python" => :build
  uses_from_macos "libxml2"
  uses_from_macos "sqlite"

  def install
    # Fix binding's rpath
    linker_flags = ["-Wl,-rpath,#{loader_path}"]

    system "cmake", "-S", ".", "-B", "build",
                    "-DNS3_GTK3=OFF",
                    "-DNS3_PYTHON_BINDINGS=OFF",
                    "-DNS3_MPI=ON",
                    "-DCMAKE_SHARED_LINKER_FLAGS=#{linker_flags.join(" ")}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "examples/tutorial/first.cc"
  end

  test do
    system ENV.cxx, "-std=c++20", "-o", "test", pkgshare/"first.cc", "-I#{include}", "-L#{lib}",
           "-lns#{version}-core", "-lns#{version}-network", "-lns#{version}-internet",
           "-lns#{version}-point-to-point", "-lns#{version}-applications"
    system "./test"
  end
end
