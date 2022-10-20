class Mmseqs2 < Formula
  desc "Software suite for very fast sequence search and clustering"
  homepage "https://mmseqs.com/"
  url "https://github.com/soedinglab/MMseqs2/archive/14-7e284.tar.gz"
  version "14-7e284"
  sha256 "a15fd59b121073fdcc8b259fc703e5ce4c671d2c56eb5c027749f4bd4c28dfe1"
  license "GPL-3.0-or-later"
  head "https://github.com/soedinglab/MMseqs2.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "53e08229adba4c2ec39c92cb25e5a4b2ad1c752aa1db17e3dc98b0b833990e91"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "156945f3cc008daa1bab32387caf5549d494c324947d27bf854a078b551763fb"
    sha256 cellar: :any_skip_relocation, monterey:       "fbf2cbc58838ccc85bab387fa504b97eedf276f4f85c8661491e657cb5fbfdd9"
    sha256 cellar: :any_skip_relocation, big_sur:        "09c83c072c409fe05bd901a1ea2fbef1bc0ee585219b13f92986619c5dbf0431"
    sha256 cellar: :any_skip_relocation, catalina:       "59a314a3ef4f816a19e129675b492e57c92747f2f25f6d4434a8bd14b933d2b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "73a3864b001a5703da8513ae515ac4de292200e555ed234af60aeab647528d9c"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "wget"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  on_macos do
    depends_on "libomp"
  end

  on_linux do
    depends_on "gawk"
  end

  resource "documentation" do
    url "https://github.com/soedinglab/MMseqs2.wiki.git",
        revision: "4cd4a50c83d72dc60d75dc79afe1b9b67b5e775d"
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
