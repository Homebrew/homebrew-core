class Ns3 < Formula
  include Language::Python::Virtualenv

  desc "Discrete-event network simulator"
  homepage "https://www.nsnam.org/"
  url "https://gitlab.com/nsnam/ns-3-dev/-/archive/ns-3.37/ns-3-dev-ns-3.37.tar.gz"
  sha256 "70f4dca7ff59eabedcdf97c75d1d8d593c726f0d75a6b9470f29871629a341f3"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "025372658342066002fda7183e7d70b5238b8dd951099230dddf24c0ababd95b"
    sha256 cellar: :any,                 arm64_monterey: "bb4cdf7466478942821f1a1449ba04f2321828d30bc68d356c3791495c0d88e8"
    sha256 cellar: :any,                 arm64_big_sur:  "1fe7dc61f8afaf84ac85159a8dd36e82cc490c7d297cdc045f544139bf32fc9d"
    sha256 cellar: :any,                 ventura:        "370908150973ec532bbecd06e4a159287cbe36a2a766a68f3d5ee7a3c22973b8"
    sha256 cellar: :any,                 monterey:       "f692d7bc0751d27840a3b34d061f937a9df20aa67a30021be3ca68951d93ea59"
    sha256 cellar: :any,                 big_sur:        "9f3bc3a14ea36660ae012397901da5e4dc31da48a711c0d7e4d8dcfe9c42d2ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "636457c0e0458503cfd38d7ef3dac11aa7235b42729624ca7c9149be0d88da94"
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
