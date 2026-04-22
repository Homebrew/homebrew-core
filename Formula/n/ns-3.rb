class Ns3 < Formula
  include Language::Python::Virtualenv

  desc "Discrete-event network simulator"
  homepage "https://www.nsnam.org/"
  url "https://gitlab.com/nsnam/ns-3-dev/-/archive/ns-3.47/ns-3-dev-ns-3.47.tar.gz"
  sha256 "d74850986ee83ac50269711686d504487dfa5b57a65b90b87f91ae256846fd64"
  license "GPL-2.0-only"

  bottle do
    sha256                               arm64_tahoe:   "78d73bf412c0a8d13a3b40ef963537c435cefd92963a187afc303f25a6462956"
    sha256                               arm64_sequoia: "47a887511315636df875b399517bdd2e2e5a6554cd2b1a7722cfb64411804e26"
    sha256                               arm64_sonoma:  "5d668b877b36d7d256ca8b21c42ef9398abe91f834f4b80e1d52c24c3cd5de5b"
    sha256                               sonoma:        "d53671ffe89ae8a854ca123aac06f9c74835f85ec30d29ec1d912025c96cdfef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c79288402f2b79215f9fcb1110615735925fb5f5f3cf5a4adecd42de7d123581"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3305e0770bc93d496281f9df99984a867ad67f8acfdc58838e07296ee9f007da"
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
