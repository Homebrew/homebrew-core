class Mmseqs2 < Formula
  desc "Software suite for very fast sequence search and clustering"
  homepage "https://mmseqs.com/"
  url "https://github.com/soedinglab/MMseqs2/archive/refs/tags/20-ae60e.tar.gz"
  version "20-ae60e"
  sha256 "0245e45b705bbcd14e46291d82c977aff0a3600200f36c4d04dceb57d211dabc"
  license "MIT"
  head "https://github.com/soedinglab/MMseqs2.git", branch: "master"

  bottle do
    manifest_sha256 "769dfbbe4e837405c778432819d2d90cf5a6c49ca3aea51bc84c8dc94ac12e50"
    sha256 cellar: :any, arm64_golden_gate: "0a24675d526cd2c32b1308f7872c56aee60ab046128fb82da873afd76142c741"
    sha256 cellar: :any, arm64_tahoe:       "e33fb37c717acc84d9e87afce3706f62c09a3003b320ace871ca2802895f8e23"
    sha256 cellar: :any, arm64_sequoia:     "72e6dec3ff417b83bed14c0b2a395d0ff3b0105e8364bc279d87e00f4f13cfae"
    sha256 cellar: :any, arm64_linux:       "2377220c3964c52375a2c7be8dee24c8da3bed63326927a1c7772a3893d049da"
    sha256 cellar: :any, x86_64_linux:      "b312c5feb28653f8b851302add8d7d20ad504897fa07f79d1ff6e909f3a47637"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "rust" => :build
  depends_on "wget"

  uses_from_macos "bzip2"

  on_macos do
    depends_on "libomp"
  end

  on_linux do
    depends_on "gawk"
    depends_on "zlib-ng-compat"
  end

  resource "homebrew-testdata", :test do
    url "https://github.com/soedinglab/MMseqs2/releases/download/12-113e3/MMseqs2-Regression-Minimal.zip"
    sha256 "ab0c2953d1c27736c22a57a1ccbb976c1320435fad82b5c579dbd716b7bae4ce"
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
    resource("homebrew-testdata").stage do
      ENV["CMAKE_POLICY_VERSION_MINIMUM"] = "3.5"
      system "./run_regression.sh", "#{bin}/mmseqs", "scratch"
    end
  end
end
