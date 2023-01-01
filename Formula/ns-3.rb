class Ns3 < Formula
  include Language::Python::Virtualenv

  desc "Discrete-event network simulator"
  homepage "https://www.nsnam.org/"
  url "https://gitlab.com/nsnam/ns-3-dev/-/archive/ns-3.37/ns-3-dev-ns-3.37.tar.gz"
  sha256 "70f4dca7ff59eabedcdf97c75d1d8d593c726f0d75a6b9470f29871629a341f3"
  license "GPL-2.0-only"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "41366faa65418e3a2bc4edcf8205ef8c255584dc41dd3e474ffb043810e3348c"
    sha256 cellar: :any,                 arm64_monterey: "3d489bfd184d65cc26ccb3b09ca005e6ddf41ce6ca15abce25c59d9a9ae95ca5"
    sha256 cellar: :any,                 arm64_big_sur:  "68aac9355130e2cc027c95b9255d150c10c817d4f9aefa94708543ecc0b20a64"
    sha256 cellar: :any,                 ventura:        "daaa6ae7d3053f5370aa7955dc1e7548dd1925706e4da43d89e4511936de2729"
    sha256 cellar: :any,                 monterey:       "3cae5abbf94429cdcef4d13f8b51ef34e16204761c29e9551332b5859854f740"
    sha256 cellar: :any,                 big_sur:        "5a88644764053c9a4852adaa074b0bcf503b1616129821afa689e7fadd5d2bb3"
    sha256 cellar: :any,                 catalina:       "5167dc9662ae8e1998bcd132c9af32b235dd848321cd357f3532d072427e763c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b46bb6dbfa98be9574f3ca0e2f69f1d0aa0749be73a868f33f6da5733259e3e9"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "gsl"
  depends_on "open-mpi"

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
    system ENV.cxx, pkgshare/"first.cc", "-I#{include}", "-L#{lib}",
           "-lns#{version}-core", "-lns#{version}-network", "-lns#{version}-internet",
           "-lns#{version}-point-to-point", "-lns#{version}-applications",
           "-std=c++17", "-o", "test"
    system "./test"
  end
end
