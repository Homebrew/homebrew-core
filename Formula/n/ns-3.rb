class Ns3 < Formula
  include Language::Python::Virtualenv

  desc "Discrete-event network simulator"
  homepage "https://www.nsnam.org/"
  url "https://gitlab.com/nsnam/ns-3-dev/-/archive/ns-3.45/ns-3-dev-ns-3.45.tar.gz"
  sha256 "ea736ba7de4baf0b4fc91cfe2ff74ac3bcd94d4e3ad7055141ddbb30f8d0fc48"
  license "GPL-2.0-only"

  bottle do
    sha256                               arm64_sequoia: "16a5e5c3ad224f1bfcb9e2820eba18c0b8c173efc439134d6bb0518875623ab6"
    sha256                               arm64_sonoma:  "62126a9fdd2c9c8add1f3afe4a07711aa54c48200f48f7b675618f0ec1555505"
    sha256                               arm64_ventura: "57b9753395cea0ab0519dc036783373e5d533fa09957c9f2768a79afabec86e0"
    sha256                               sonoma:        "2e76d35afec9a8ff072481604cb44fd37a9a1f5d8d97b34927e39c6879482b10"
    sha256                               ventura:       "adf133d189b26d97496f0c8d44c33438174b4fd521b79eda5a197e3914d87683"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "16990f583b68561b0e280ae2a94601b3eaac8f55f43821f98752c9ac8b003e64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9789a8feeb782f96928c7b0dab8222333f79f8390859dbf57cae226b35fcc35a"
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
