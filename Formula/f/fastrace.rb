class Fastrace < Formula
  desc "Dependency-free traceroute implementation in pure C"
  homepage "https://github.com/davidesantangelo/fastrace"
  url "https://github.com/davidesantangelo/fastrace/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "2306b081389a98486167707733ace0e5811bd154eaf0beffd9f144e081c94ad9"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6833c864db6517ac2ef3272dc90fc1925e9b6709437a866b13f2c30e87fe2c2f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "687adb6279fac2aa3a2d12ef7d336a78687285a9336a4d96c03bf8aca55f4cfc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "143884514ed4a17b722d1b947fd397e1518c2fd4243be19d4ab555906b590c6d"
    sha256 cellar: :any_skip_relocation, sonoma:        "1f5b5fe7dc3f03aee9127ecfc80fd225f01e79d580c1a1fa88351d0e136c0c59"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8710b017eb68e6e7bb3f34e128b4d490a5bceb66da91f31bb2801fe0c1fe7408"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9085419115cfb56b6b9f296442071c81da92b8d1d416f575e643d40f64e02be9"
  end

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fastrace -V")

    assert_match "Error creating ICMP receive socket", shell_output("#{bin}/fastrace brew.sh 2>&1", 1)
  end
end
