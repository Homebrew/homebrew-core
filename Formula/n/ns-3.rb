class Ns3 < Formula
  desc "Discrete-event network simulator"
  homepage "https://www.nsnam.org/"
  url "https://gitlab.com/nsnam/ns-3-dev/-/archive/ns-3.48/ns-3-dev-ns-3.48.tar.gz"
  sha256 "23a4c2606281ca534e0d4ab4b90d47ed3d4f82f52c94667b890bbb90ea113e9e"
  license "GPL-2.0-only"

  bottle do
    sha256               arm64_tahoe:   "7f01602985607329ad35fa27eadcd484c8b8f26a5642c92836c31c297995f9bf"
    sha256               arm64_sequoia: "6dfa93ac72c007e371a363cd1956effaa3cd2a542b2dbed2b45c57c38d4d3547"
    sha256               arm64_sonoma:  "9b9a0e7ae9ac9ffcfa010c55cbb87eb3a77ae702b0e75c945ba24622ceb802f6"
    sha256               sonoma:        "19e4aafa35b9e75b371921013c70e42404cdc6c9f77fbcb480bc94bb81d9af95"
    sha256 cellar: :any, arm64_linux:   "86cb6535b65f1f125def0b5a55ebba9e334a9dcf47ec083c2396bd922d6739ba"
    sha256 cellar: :any, x86_64_linux:  "f55522488a2ee0e0aa53cfe92a392ca7a3e032d2248d3176a571926725fe6f37"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "open-mpi"

  uses_from_macos "python" => :build
  uses_from_macos "libxml2"
  uses_from_macos "sqlite"

  def install
    # Fix binding's rpath
    linker_flags = ["-Wl,-rpath,#{loader_path}"]

    # NOTE: Do not enable GSL support as it is GPL-3.0-or-later which is
    # incompatible with GPL-2.0-only resulting in non-distributable binaries.
    # See https://www.gnu.org/licenses/gpl-faq.html#AllCompatibility
    args = %W[
      -DNS3_GSL=OFF
      -DNS3_GTK3=OFF
      -DNS3_PYTHON_BINDINGS=OFF
      -DNS3_MPI=ON
      -DCMAKE_SHARED_LINKER_FLAGS=#{linker_flags.join(" ")}
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
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
