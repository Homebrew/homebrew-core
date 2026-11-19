class Mmseqs2 < Formula
  desc "Software suite for very fast sequence search and clustering"
  homepage "https://mmseqs.com/"
  url "https://github.com/soedinglab/MMseqs2/archive/refs/tags/19-ab57c.tar.gz"
  version "19-ab57c"
  sha256 "68b20700b82c93f2a30a8a7fbe545ab6ec715bfccb13ddcab144d3f3f504c5a4"
  license "MIT"
  head "https://github.com/soedinglab/MMseqs2.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "c50cce6f94df5fa2387ee927f4057ede16c30bc06df7a26924c680ea9b6f079a"
    sha256 cellar: :any, arm64_tahoe:       "345673be616f68f684e40d90d3a46a0afe54ef230bb3e85816f0faa4c7aff9ca"
    sha256 cellar: :any, arm64_sequoia:     "cbee345ec5521f759bff4f321caec21e717bf13c578a4fafdca3587a885d4b04"
    sha256 cellar: :any, arm64_linux:       "945c35bbc777811cf5ec31ad6952805a5775cca87fd40af02fe8da44cea90459"
    sha256 cellar: :any, x86_64_linux:      "d5fbde9b4b0c530f5912a56f6fc18b6b6c7a437964f072abfdfb95ab900cbd98"
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
