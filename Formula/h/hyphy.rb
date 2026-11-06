class Hyphy < Formula
  desc "Hypothesis testing using Phylogenies"
  homepage "https://www.hyphy.org"
  url "https://github.com/veg/hyphy/archive/refs/tags/2.5.104.tar.gz"
  sha256 "608b16322071453812be3c032d9ab575c74d245969c03dca298b2a041933d6a0"
  license "MIT"
  head "https://github.com/veg/hyphy.git", branch: "master"

  bottle do
    sha256 arm64_golden_gate: "b1018e682c0a1c86a6e520c2c66bcef1e77aad6934038f75bd6688374301b75a"
    sha256 arm64_tahoe:       "b067ed0bbd1da88d831fa6b1c8a15ed4e293cd2b94132fc97f3e64e69cdd5c65"
    sha256 arm64_sequoia:     "6090d09d58c263cc947290f1db06e7522902c571e4529c36cf0edd32ee61b729"
    sha256 arm64_linux:       "244af4c673d50a544a923044f62105745dd87c9f949e5c5452e478dcb8affc37"
    sha256 x86_64_linux:      "8e9080a29c53f7ae5343b661151af6c928b57c628f2e0c202d50e7730926827e"
  end

  depends_on "cmake" => :build

  uses_from_macos "curl"

  on_macos do
    depends_on "libomp"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hyphy --version")

    cp pkgshare/"data/p51.nex", testpath
    system bin/"hyphy", "slac", "--alignment", "p51.nex"
    assert_path_exists "p51.nex.SLAC.json"
  end
end
