class Ns3 < Formula
  desc "Discrete-event network simulator"
  homepage "https://www.nsnam.org/"
  url "https://gitlab.com/nsnam/ns-3-dev/-/archive/ns-3.47/ns-3-dev-ns-3.47.tar.gz"
  sha256 "d74850986ee83ac50269711686d504487dfa5b57a65b90b87f91ae256846fd64"
  license "GPL-2.0-only"

  bottle do
    rebuild 1
    sha256                               arm64_tahoe:   "cdf607dc89940207d2e7982674e81f87f387c3811a0410fdb61b003c1bc1da63"
    sha256                               arm64_sequoia: "6f5337ebc42ceec3f7a49d32231cc01bec5485cd1daf20b13c750cd5743d93fa"
    sha256                               arm64_sonoma:  "5efeafd44257400eac0ad1f841492b4924e839a7dd14fc925a670504f38399d0"
    sha256                               sonoma:        "7f321975447753e729e7a5768c6bc107b2706c093bb21a40b7edb08dbb586a38"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8492c3ca7c872d76fd1ba938a1e0ee32e5b1e89a302c69106382a9722c8263a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "214b69cc493eb45e7682b23fb027b586cf223a84f16a5652257c8ab3e6d3231d"
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
