class Mmseqs2 < Formula
  desc "Software suite for very fast sequence search and clustering"
  homepage "https://mmseqs.com/"
  url "https://github.com/soedinglab/MMseqs2/archive/refs/tags/15-6f452.tar.gz"
  version "15-6f452"
  sha256 "7115ac5a7e2a49229466806aaa760d00204bb08c870e3c231b00e525c77531dc"
  license "GPL-3.0-or-later"
  head "https://github.com/soedinglab/MMseqs2.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "aba00dd8dbc099db31639822589c2a289436f78f47415c9bbb52da46c333f53f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c88e8b511aedbf0abab55d03e24ce5a0d55c0430030cd31e0c147c98bfa535bd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "512741ad23baa4dce0feb17bae9d4b191ae0ddade26612dba3c1efdf3c72dcb1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f88414971f7399d1993419af08bbd06d4ab82abc001e9f78ccde868b844f6a65"
    sha256 cellar: :any_skip_relocation, sonoma:         "a3e04a294a1db787b11ec79f3f6b7a7b4369c696760d87e7c398b3eee668fb4d"
    sha256 cellar: :any_skip_relocation, ventura:        "4b5c561f19f57c6daa8dac8a9f00d44c7ea38fb85c55831461fbe8ead7700e89"
    sha256 cellar: :any_skip_relocation, monterey:       "9c1d25760313d5aa0f70ced3d98118124c6e5512cb612dc37e56cb169bc611c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "204d92d9cfc945c5e4d4cdf665afca20f0236b4a33942f242b759f0238827d03"
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

  # check revision with https://github.com/soedinglab/MMseqs2/wiki/Home/_history
  resource "documentation" do
    url "https://github.com/soedinglab/MMseqs2.wiki.git",
        revision: "1ea9a93cb31d6c8cc25ef963311bcdddb95ff58d"
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
      args << "-DOpenMP_C_FLAGS=-Xpreprocessor -fopenmp -I#{libomp.opt_include}"
      args << "-DOpenMP_C_LIB_NAMES=omp"
      args << "-DOpenMP_CXX_FLAGS=-Xpreprocessor -fopenmp -I#{libomp.opt_include}"
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
    on_intel do
      "MMseqs2 requires at least SSE4.1 CPU instruction support." unless Hardware::CPU.sse4?
    end
  end

  test do
    resource "homebrew-testdata" do
      url "https://github.com/soedinglab/MMseqs2/releases/download/12-113e3/MMseqs2-Regression-Minimal.zip"
      sha256 "ab0c2953d1c27736c22a57a1ccbb976c1320435fad82b5c579dbd716b7bae4ce"
    end

    resource("homebrew-testdata").stage do
      system "./run_regression.sh", "#{bin}/mmseqs", "scratch"
    end
  end
end
