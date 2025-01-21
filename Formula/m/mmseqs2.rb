class Mmseqs2 < Formula
  desc "Software suite for very fast sequence search and clustering"
  homepage "https://mmseqs.com/"
  url "https://github.com/soedinglab/MMseqs2/archive/refs/tags/17-b804f.tar.gz"
  version "17-b804f"
  sha256 "300ebd14bf4e007b339037e5f73d8ff9c4e34f8495204c4a8c59c7672b689db2"
  license "MIT"
  head "https://github.com/soedinglab/MMseqs2.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c8daf8dbec7c29c1d3eea5a0121219586ed24ea957d12e00acadb2e290fb96b3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1896588e7c11aecd04b53c19c6ab529f3800ad15f8f4ec7d95d007b486a009eb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e677b94b349b48bfd2d2840db79407fc00055c4780690cd8434b94bf1f288f41"
    sha256 cellar: :any_skip_relocation, sonoma:        "a4fa462c8bb251cdd7076cc6afe8a25484f676fde45d45e4ce8637e742063e97"
    sha256 cellar: :any_skip_relocation, ventura:       "137d46f6776eeff0b856cf2eca03c972b49a50238ce083d0f7c7782e2f1eb6d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9f75c259b582cc4cf86ee97be763e59f9590e58d4f67a43b5e213bcc8a283401"
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

  # `git ls-remote https://github.com/soedinglab/MMseqs2.wiki.git HEAD`
  resource "documentation" do
    url "https://github.com/soedinglab/MMseqs2.wiki.git",
        revision: "b1ccffcaf6be0f857e37670a260311f2416b6794"
  end

  def install
    args = %W[
      -DHAVE_TESTS=0
      -DHAVE_MPI=0
      -DVERSION_OVERRIDE=#{version}
    ]

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

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

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
