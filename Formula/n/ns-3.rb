class Ns3 < Formula
  include Language::Python::Virtualenv

  desc "Discrete-event network simulator"
  homepage "https://www.nsnam.org/"
  url "https://gitlab.com/nsnam/ns-3-dev/-/archive/ns-3.46.1/ns-3-dev-ns-3.46.1.tar.gz"
  sha256 "3cb25d4ce1fb5c8597c91ab3d14c52a9f37eff92c36c2961772966c440850171"
  license "GPL-2.0-only"
  revision 1

  bottle do
    sha256                               arm64_tahoe:   "056ad158ebdcf047c7326fdf17a978fcc6d4163d76ab8d6ce8e9f307f9ebeeb0"
    sha256                               arm64_sequoia: "d22d30dcce8d6c063c9ed33b784fc5a83615e1ee9a4870e6cd8f8e6a104cf75e"
    sha256                               arm64_sonoma:  "77bda72c0389cbc365aae61b2184047cc3f6eed1a6c1bc8fc056f96884d626ad"
    sha256                               sonoma:        "1bfca6a9c11da394758d98720f00ac08737f100600e6512975f889f8088fcf56"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f210ed90adcdfc7243fd9a6058ca6723f6ce7c5f1c28adacd99fe3ac2a4bd871"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d809b943bc13cb7e20247616806148a3fcbe5ef7d99adcf5e7f3e5ecdfd52f09"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "gsl"
  depends_on "open-mpi"

  uses_from_macos "python" => :build
  uses_from_macos "libxml2"
  uses_from_macos "sqlite"

  def install
    # Fix to error: no matching function for call to ‘find...’
    # Issue ref: https://gitlab.com/nsnam/ns-3-dev/-/issues/1264
    inreplace "src/core/model/test.cc", "#include <vector>", "#include <vector>\n#include <algorithm>"

    # Fix binding's rpath
    linker_flags = ["-Wl,-rpath,#{loader_path}"]

    args = %W[
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
