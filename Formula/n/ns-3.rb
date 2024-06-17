class Ns3 < Formula
  include Language::Python::Virtualenv

  desc "Discrete-event network simulator"
  homepage "https://www.nsnam.org/"
  url "https://gitlab.com/nsnam/ns-3-dev/-/archive/ns-3.42/ns-3-dev-ns-3.42.tar.gz"
  sha256 "c31f8e7615ffe55b31f9592f4ea04c6516c3e6855a58480f897fb1169650131b"
  license "GPL-2.0-only"
  revision 1

  bottle do
    sha256                               arm64_sonoma:   "95a92f33c798afcab4034cfe9e188876877fc1a03fd9c4c5448be1e5abaa5bde"
    sha256                               arm64_ventura:  "ecee931f8eb399abd996257b41b2b5da65e0acf6817722acd2e067fe55c2a715"
    sha256                               arm64_monterey: "ac7e6a0a5ea664e91e65714dfde4d5f2f617095ccad59b56a08882f0bfb583aa"
    sha256                               sonoma:         "8034226b16d84cf4f8acd18e2a14fe2a766e12691c65d1bc4616cdb036be3050"
    sha256                               ventura:        "a8fe5cb6a63e8c9566f380be305cacd62ee0d999c5e72a67646db81f6d417d59"
    sha256                               monterey:       "43fc3b98c8d605e1ec0c1524d05a76059bd99d0207267b4db43da6211f8e8fea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d2bc007cdd4ddcaafe8fe01edb0df1411b8f5e1570091d8e0e79bb229f1b7b4"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "gsl"
  depends_on "open-mpi"

  uses_from_macos "python" => :build
  uses_from_macos "libxml2"
  uses_from_macos "sqlite"

  # build patch for `error: variable 'index' set but not used`
  # upstream patch pr, https://gitlab.com/nsnam/ns-3-dev/-/merge_requests/2019
  patch do
    url "https://gitlab.com/nsnam/ns-3-dev/-/commit/0f3e29041b2f6e4ea23026e401da54efe1b77e59.diff"
    sha256 "86ee319a7c49c24a7595a7c19fe7112cf2d64f2d60d79c17327e0a7daae91068"
  end

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
