class Mmseqs2 < Formula
  desc "Software suite for very fast sequence search and clustering"
  homepage "https://mmseqs.com/"
  url "https://github.com/soedinglab/MMseqs2/archive/12-113e3.tar.gz"
  version "12-113e3"
  sha256 "81fa0d77eab9d74b429567da00aa7ec2d46049537ce469595d7356b6d8b5458a"
  license "GPL-3.0-or-later"
  revision 1
  head "https://github.com/soedinglab/MMseqs2.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "680c7da7213bd418914740e3b7136ab839003ac287b586240982adecf8b1eaeb" => :big_sur
    sha256 "586f29f2865f69e7947fd57f7da464a0437f13a3c47924ec857b4f89e7c7ffa5" => :arm64_big_sur
    sha256 "2187f9ec5272d2f5c51fbe24d8b3a266b0441b17cd88b48cc9e30f28cfb9c8e6" => :catalina
    sha256 "024422927bed2dd5a769255b6639d76ca4128bd27cd3d0717866847fa4d4468f" => :mojave
  end

  depends_on "cmake" => [:build, :test]
  depends_on "libomp"
  depends_on "wget"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  resource "documentation" do
    url "https://github.com/soedinglab/MMseqs2.wiki.git",
        revision: "d53d8be3761ee625b0dcddda29b092bbd02244ef"
  end

  resource "testdata" do
    url "https://github.com/soedinglab/MMseqs2/releases/download/12-113e3/MMseqs2-Regression-Minimal.zip"
    sha256 "ab0c2953d1c27736c22a57a1ccbb976c1320435fad82b5c579dbd716b7bae4ce"
  end

  def install
    args = *std_cmake_args << "-DHAVE_TESTS=0" << "-DHAVE_MPI=0"
    args << "-DVERSION_OVERRIDE=#{version}"
    args << if Hardware::CPU.arm?
      "-DHAVE_ARM8=1"
    else
      "-DHAVE_SSE4_1=1"
    end

    libomp = Formula["libomp"]
    args << "-DOpenMP_C_FLAGS=-Xpreprocessor\ -fopenmp\ -I#{libomp.opt_include}"
    args << "-DOpenMP_C_LIB_NAMES=omp"
    args << "-DOpenMP_CXX_FLAGS=-Xpreprocessor\ -fopenmp\ -I#{libomp.opt_include}"
    args << "-DOpenMP_CXX_LIB_NAMES=omp"
    args << "-DOpenMP_omp_LIBRARY=#{libomp.opt_lib}/libomp.a"

    # Fix SIMDe on AppleClang11, fixed upstream, remove in next release
    args << "-DCMAKE_CXX_FLAGS=-DSIMDE_NO_CHECK_IMMEDIATE_CONSTANT=1" if DevelopmentTools.clang_build_version == 1100

    system "cmake", ".", *args
    system "make", "install"

    resource("documentation").stage { doc.install Dir["*"] }
    pkgshare.install "examples"
    bash_completion.install "util/bash-completion.sh" => "mmseqs.sh"
  end

  def caveats
    "MMseqs2 requires at least SSE4.1 CPU instruction support." if !Hardware::CPU.sse4? && !Hardware::CPU.arm?
  end

  test do
    resource("testdata").stage do
      system "./run_regression.sh", "#{bin}/mmseqs", "scratch"
    end
  end
end
