class Mmseqs2 < Formula
  desc "Software suite for very fast sequence search and clustering"
  homepage "https://mmseqs.com/"
  url "https://github.com/soedinglab/MMseqs2/archive/refs/tags/18-8cc5c.tar.gz"
  version "18-8cc5c"
  sha256 "3541b67322aee357fd9ca529750d36cb1426aa9bcd1efb2dc916e35219e1a41c"
  license "MIT"
  head "https://github.com/soedinglab/MMseqs2.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any, arm64_golden_gate: "e4736d89e25b826e72cd9d0674e36c18ff48118e614718ecd3bd21c25f2a1f09"
    sha256 cellar: :any, arm64_tahoe:       "cde948e5fd9bd5fc4712ca3da68732f40f07d67904b1368b388c58adf57db676"
    sha256 cellar: :any, arm64_sequoia:     "61f15901cee4c6e69ef77101ca8b4f519f603d80e5e05ffb8c647a06fc7ffd53"
    sha256 cellar: :any, arm64_sonoma:      "35e3e29a68022cd9aba6c865a67deeeac57ef771fee8f11282a49a677258e3c1"
    sha256 cellar: :any, arm64_linux:       "ecd13dca0300d49a7f1be7272cea1217a7f2782a2bc8e7c89c4f40ee41469f03"
    sha256 cellar: :any, x86_64_linux:      "bcad178647ca4c1639e7714f3a776743b472446e7b9bd744c7abbe0792c6469e"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "wget"

  uses_from_macos "bzip2"

  on_macos do
    depends_on "libomp"
  end

  on_linux do
    depends_on "gawk"
    depends_on "zlib-ng-compat"
  end

  allow_network_access! :test

  def install
    args = %W[
      -DHAVE_TESTS=0
      -DHAVE_MPI=0
      -DVERSION_OVERRIDE=#{version}
    ]

    args << if Hardware::CPU.arm?
      "-DHAVE_ARM8=1"
    else
      "-DHAVE_SSE2=1" # need to support Core 2
    end

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

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
