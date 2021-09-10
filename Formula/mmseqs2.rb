class Mmseqs2 < Formula
  desc "Software suite for very fast sequence search and clustering"
  homepage "https://mmseqs.com/"
  url "https://github.com/soedinglab/MMseqs2/archive/13-45111.tar.gz"
  version "13-45111"
  sha256 "6444bb682ebf5ced54b2eda7a301fa3e933c2a28b7661f96ef5bdab1d53695a2"
  license "GPL-3.0-or-later"
  head "https://github.com/soedinglab/MMseqs2.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "510d513310f2372e90eb1cd63a3e03e8f86e92d286fc9bc28e11c64c6e953ebb"
    sha256 cellar: :any_skip_relocation, big_sur:       "9c77c3321deb69aa84df7326821c803ecd377dc3f91931c26ca030832c25ee80"
    sha256 cellar: :any_skip_relocation, catalina:      "f52feb3e6c03379981c6d7af2f2a3d404b0f0eb20ef2de490c1e8d67bd03ef54"
    sha256 cellar: :any_skip_relocation, mojave:        "72a26a3d303d4150154c8200893ae6f4554b5eb1fe93a24d86c3b88d90aa1a3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c007b75f505bb8b2672da63d4c2d373f1e6162e924172ac52e2f57290548a572"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "libomp"
  depends_on "wget"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  on_linux do
    depends_on "gawk"
  end

  resource "documentation" do
    url "https://github.com/soedinglab/MMseqs2.wiki.git",
        revision: "790eb1b49f460d6054d5b8a6a643b8543f166388"
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

    if OS.mac?
      libomp = Formula["libomp"]
      args << "-DOpenMP_C_FLAGS=-Xpreprocessor\ -fopenmp\ -I#{libomp.opt_include}"
      args << "-DOpenMP_C_LIB_NAMES=omp"
      args << "-DOpenMP_CXX_FLAGS=-Xpreprocessor\ -fopenmp\ -I#{libomp.opt_include}"
      args << "-DOpenMP_CXX_LIB_NAMES=omp"
      args << "-DOpenMP_omp_LIBRARY=#{libomp.opt_lib}/libomp.a"
    end

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
