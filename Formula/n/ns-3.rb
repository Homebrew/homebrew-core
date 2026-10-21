class Ns3 < Formula
  desc "Discrete-event network simulator"
  homepage "https://www.nsnam.org/"
  url "https://gitlab.com/nsnam/ns-3-dev/-/archive/ns-3.49/ns-3-dev-ns-3.49.tar.gz"
  sha256 "da24e895f41f7480e3b80fce0f9eca76923de1ea8848b5fb72cdae5b24b94b79"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "fb65040d542a2f21533f9e0afcd390fe2a436bdbe0f3259651f4b891d73e406c"
    sha256 cellar: :any, arm64_tahoe:       "d01683a47fd26a044b332e19e3b9d2d60186b64a4da672ccd57ac05a5aac5cbb"
    sha256 cellar: :any, arm64_sequoia:     "ad22693e94e385f84e5297e3820739a5924f787a08da6a252d997625f3c22050"
    sha256 cellar: :any, arm64_linux:       "4947b637932d89a9b32e1fd26250e08395d6a647c292a1e735805b38064dad76"
    sha256 cellar: :any, x86_64_linux:      "0c81810016d928de6580040fc11d7c56ec0edef850d77779f8321abf68bb9af8"
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
