class Hyphy < Formula
  desc "Hypothesis testing using Phylogenies"
  homepage "https://www.hyphy.org"
  url "https://github.com/veg/hyphy/archive/refs/tags/2.5.103.tar.gz"
  sha256 "e3602aa3add7f4d88c18038828bc49080a749dd377f9d41c92933fbf07d846c2"
  license "MIT"
  head "https://github.com/veg/hyphy.git", branch: "master"

  bottle do
    sha256 arm64_golden_gate: "3697197128a0d8fa47732fcd170e00cad640128f566f6b4ed89e66dc6ab3c55d"
    sha256 arm64_tahoe:       "b101d8a59fc60a19144aa60fc27c3b70634e2e2aa4f7ed849335290ec2657a6d"
    sha256 arm64_sequoia:     "a222eaa19a6991771f70590c9b225c5f00bae1530970cff112859279099262e1"
    sha256 arm64_linux:       "d1e4f009ac57e9b2afa5b6d42552419c38e6fb064fb4fbc046d8c7163cb972d5"
    sha256 x86_64_linux:      "d792b20fbb7edf78f5e7466272c58b5ec56164f9325aef591acbdb2ebb903e33"
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
