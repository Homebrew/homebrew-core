class Ns3 < Formula
  include Language::Python::Virtualenv

  desc "Discrete-event network simulator"
  homepage "https://www.nsnam.org/"
  url "https://gitlab.com/nsnam/ns-3-dev/-/archive/ns-3.42/ns-3-dev-ns-3.42.tar.gz"
  sha256 "c31f8e7615ffe55b31f9592f4ea04c6516c3e6855a58480f897fb1169650131b"
  license "GPL-2.0-only"

  bottle do
    sha256                               arm64_sonoma:   "8c69705c4cb9e6c9a6479db916d7d00e03e2c5ec448740235aa9795d38271ce6"
    sha256                               arm64_ventura:  "726baa64041c041c0547287c855db06dd51d61ed83ac9786e6860dff552a6004"
    sha256                               arm64_monterey: "dcb6d216690ea923c2cd4c59149859ca8f79782869fb9a9b2bb714c7cf2ca00f"
    sha256                               sonoma:         "39d783975784841ffeab3d0019a493fe522b1c0d42888baf8dafc57927f19abb"
    sha256                               ventura:        "f050e46918ba1c3d3a3af49e9351f18e2164add8e8ab98eb6db9dad389479df4"
    sha256                               monterey:       "a776361766b89e7f8929266b04603a440b99e143934a3912c2b08c330b6f67e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab3eb94031d918009293be8ada5ab1359012de1e74f9ff799015b1e905836629"
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
