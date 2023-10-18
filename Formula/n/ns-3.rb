class Ns3 < Formula
  include Language::Python::Virtualenv

  desc "Discrete-event network simulator"
  homepage "https://www.nsnam.org/"
  url "https://gitlab.com/nsnam/ns-3-dev/-/archive/ns-3.40/ns-3-dev-ns-3.40.tar.gz"
  sha256 "1ace4a73b83ce6d087f104c5d58f749bf5ba4f18b5c3c5fd2b18f2cbaf735dca"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "81e518bfce152223d84d7c46a775660b7226e012f6560b437dd3bee62e6feadf"
    sha256 cellar: :any,                 arm64_ventura:  "24d505ccf11483beaacea36eeea74fbea0e10734965a723a548a5f0a350bacb1"
    sha256 cellar: :any,                 arm64_monterey: "95dc9e6e818df8ca655d3621ff2e42f1e0625d464105f70868c0e0cfde42688b"
    sha256 cellar: :any,                 sonoma:         "438e1d4ba03e332bb9fe3f48a14a810ac32b48270615137f2fcb16a016ccd2c6"
    sha256 cellar: :any,                 ventura:        "3dd9eebcec0e8d4e8417a8a8a655c653dfcaf52c4edb2542a2318939d29a27c4"
    sha256 cellar: :any,                 monterey:       "2ad19888711cfafc2007e8abb7855c940ab04b1b45b7cf739665b4607d354e0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "08a791dc36a19c0ac67363fe0d84a9292ec46cd7e80b175466a8959ce482486e"
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
    system ENV.cxx, pkgshare/"first.cc", "-I#{include}", "-L#{lib}",
           "-lns#{version}-core", "-lns#{version}-network", "-lns#{version}-internet",
           "-lns#{version}-point-to-point", "-lns#{version}-applications",
           "-std=c++17", "-o", "test"
    system "./test"
  end
end
