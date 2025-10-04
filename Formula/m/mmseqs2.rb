class Mmseqs2 < Formula
  desc "Software suite for very fast sequence search and clustering"
  homepage "https://mmseqs.com/"
  url "https://github.com/soedinglab/MMseqs2/archive/refs/tags/18-8cc5c.tar.gz"
  version "18-8cc5c"
  sha256 "3541b67322aee357fd9ca529750d36cb1426aa9bcd1efb2dc916e35219e1a41c"
  license "MIT"
  head "https://github.com/soedinglab/MMseqs2.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7b06159dad576a5e58ea3432b635167d4944540afe004fcb3f115b18a8850e30"
    sha256 cellar: :any,                 arm64_sequoia: "2559af59e1218ea74307ceec6566773a99644344cf79f2694feb3087b47d7c52"
    sha256 cellar: :any,                 arm64_sonoma:  "51c387d84616d349170b24f6d19a8013da1a38b26ce1470e288858ddfaaffee9"
    sha256 cellar: :any,                 arm64_ventura: "3588b255d84d1990d827384f1d1f0580e289a07df361f2ebb3cbfc8f11ee00ae"
    sha256 cellar: :any,                 sonoma:        "34bd808b80f87b6aefb521847f10507a27367686616a4de7f121249a9f087044"
    sha256 cellar: :any,                 ventura:       "e077f4ccbbfd477edd045872df1e891a1038f7f2e2a52d3c72c390367ae8208c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3be48f38aa44ce99a5a96d6b67b6c54645c9e25a091aa32b8e289bc0037c3659"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd3f8a5bfe07ba3c31860971f628f04a5bec4c49606f732641b27aabccac3f4a"
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
        revision: "67ba9c6637b4b5121a73e5de034dd0c3414d2b81"
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

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    resource("documentation").stage { doc.install Dir["*"] }
    pkgshare.install "examples"
    bash_completion.install "util/bash-completion.sh" => "mmseqs.sh"
  end

  test do
    resource "homebrew-testdata" do
      url "https://github.com/soedinglab/MMseqs2/releases/download/12-113e3/MMseqs2-Regression-Minimal.zip"
      sha256 "ab0c2953d1c27736c22a57a1ccbb976c1320435fad82b5c579dbd716b7bae4ce"
    end

    resource("homebrew-testdata").stage do
      ENV["CMAKE_POLICY_VERSION_MINIMUM"] = "3.5"
      system "./run_regression.sh", "#{bin}/mmseqs", "scratch"
    end
  end
end
