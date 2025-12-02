class Mbw < Formula
  desc "Memory Bandwidth Benchmark"
  homepage "https://github.com/raas/mbw/"
  url "https://github.com/raas/mbw/archive/refs/tags/v2.0.tar.gz"
  sha256 "557f670e13ff663086fe239e4184d8ca6154b004bd5fde2b0a748e5aa543c87f"
  license "GPL-3.0-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "1c8c88e772ba5c6cc57af7b79c0520750566523f94d643c00f5355333d176836"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "5d07a9cad29f80e14aa0abab7e8b5519729e401d876e84b59b400f5413a85a3a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "43bba75f10ec5e1d0dead83ec5b9549e9c5afaec052c3b5684fe8dbebd485819"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8d8c490ebba8f65126392a3a5c15ecbd7531217b5f87a7e7f4c3de239d794c34"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c508f7394113b7bbfa8d128c8a67321a8539e212cca8384f63d16688a98c52dd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "15ee30ee71405b25533e14618bd3541da3f13e310754e39278cef4a1f06eb6d9"
    sha256 cellar: :any_skip_relocation, sonoma:         "e0d410a21a09a4a2da43b61128be02c0c4ff95381376036b7ae6ebb4f44e4cca"
    sha256 cellar: :any_skip_relocation, ventura:        "0e7ba7c958e2386d613322712c44a50c3f3aaf22ec663fb550c84b3d2537ce09"
    sha256 cellar: :any_skip_relocation, monterey:       "356d3527bf46cd56f25f2f8ed5e6150115fb3ec175100493c98ffbbafefa1344"
    sha256 cellar: :any_skip_relocation, big_sur:        "63a8ba9a5eb2ffaf44f1535b8c3bcac2bd3ebc912a6daceae2ee01df6c89b13b"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "59fb54c3415e043a4eb29261d56613411126d676837894f159f6cb54d438ee0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "07ba5ff41d1031bc549c646c8d7bfc9082ce02b0572d437cb0c840855814ebf0"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match "AVG\tMethod: MEMCPY\tElapsed", pipe_output("#{bin}/mbw 8", "0")
  end
end
