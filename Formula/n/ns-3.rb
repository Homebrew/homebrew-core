class Ns3 < Formula
  include Language::Python::Virtualenv

  desc "Discrete-event network simulator"
  homepage "https://www.nsnam.org/"
  url "https://gitlab.com/nsnam/ns-3-dev/-/archive/ns-3.43/ns-3-dev-ns-3.43.tar.gz"
  sha256 "45c33fddf95195a51a5929341fa3e1ff0f1e6f01e7049a06216ced509256c7f3"
  license "GPL-2.0-only"

  bottle do
    sha256                               arm64_sequoia: "b6318cc6fc405c621489ec232845c47ed6803fe08f4ed19826290932d52a820d"
    sha256                               arm64_sonoma:  "c772e9dbfc8736fe744de2810c663c3dad63beea603341110ff3e1ff8ef088d0"
    sha256                               arm64_ventura: "d201dcc8e9002a69b6cb1355e9ddd1968e98a679b92415b01bd19a20393d17ac"
    sha256                               sonoma:        "7937bdf9b3dab13f7090d78dd5d7b95f099b094460431a5edea6fb2dddd102c5"
    sha256                               ventura:       "06cad0f469a9e59a5b63c4531b4da59920f29de396ae9503334f42f0c47317a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8dc43626ba9e906d66ddf573b9c1188da8298fdf8a94aae943d857119a3d1430"
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
