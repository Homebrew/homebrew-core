class Mmseqs2 < Formula
  desc "Software suite for very fast sequence search and clustering"
  homepage "https://mmseqs.com/"
  url "https://github.com/soedinglab/MMseqs2/archive/14-7e284.tar.gz"
  version "14-7e284"
  sha256 "a15fd59b121073fdcc8b259fc703e5ce4c671d2c56eb5c027749f4bd4c28dfe1"
  license "GPL-3.0-or-later"
  head "https://github.com/soedinglab/MMseqs2.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "67ab6bae6d53d0ae65dd6a49f0d5dbe57eacf817ce7c0d684b8b54b845d1af61"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "17c64802df51661ae64fab38d1ef34d6fd5764b22fb0b9d741c5e67f713593f2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "efe40f0e8d4ffa862f09aec630203447d41f4d3a568e8639a7b9443367f7f2c1"
    sha256 cellar: :any_skip_relocation, ventura:        "bfd8aa126d8adce2baa635fd49378f41f7016aef8a1d5f4039b5c8487ea330eb"
    sha256 cellar: :any_skip_relocation, monterey:       "a204fe616c7f2daa544a27354cc2fdfa3d887a6fa7e5b46dd3b6082881bc0d41"
    sha256 cellar: :any_skip_relocation, big_sur:        "89e1fcf1aad609ac81b1c6a739ae2f27eb507c374409a26f9a5b3ead1a4036a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5915a38fefb90dd7ed9922354b9842a27c843536e318067937112b2f34959b29"
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
    resource("testdata").stage do
      system "./run_regression.sh", "#{bin}/mmseqs", "scratch"
    end
  end
end
