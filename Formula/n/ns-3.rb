class Ns3 < Formula
  include Language::Python::Virtualenv

  desc "Discrete-event network simulator"
  homepage "https://www.nsnam.org/"
  url "https://gitlab.com/nsnam/ns-3-dev/-/archive/ns-3.41/ns-3-dev-ns-3.41.tar.gz"
  sha256 "1b11d609e26cfb684404e77f44a3951f4d238220618b0bdbfc766a701c1cc5a8"
  license "GPL-2.0-only"

  bottle do
    sha256                               arm64_sonoma:   "6cf3605f0a9fb683a76e9adaa8fa3cefc0b9635fa5f87b9b9fc5ac1c33a8bea3"
    sha256                               arm64_ventura:  "20a493bcb8845aa5f452c2ae666e21e40e5539644f1cde73e58f1045536ceaa3"
    sha256                               arm64_monterey: "ec56905a4e544d6918279421312e46caaa018f9cf0de46a12c541cf078906bd5"
    sha256                               sonoma:         "17182b7c229843f5a4862edcc8074fe28edc8b2a69852a12bb6bc3ffe5ea2168"
    sha256                               ventura:        "66ef43e3677a67e7bea71b5d202ed7cbcf3f91c7f698ffd52e8451448493aa96"
    sha256                               monterey:       "a2e5369d19cdff1228740525c6fff05c4ca1cab49510a9a537d5c3802d8e43d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "97f7791df1cfb810a587faeed6ebced1cea95ea124ea7f74503af2c4856d8d66"
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
