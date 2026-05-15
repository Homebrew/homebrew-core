class Hyphy < Formula
  desc "Hypothesis testing using Phylogenies"
  homepage "https://www.hyphy.org"
  url "https://github.com/veg/hyphy/archive/refs/tags/2.5.98.tar.gz"
  sha256 "a2910238d1c641bed66cce409cec3f0a0488038e9f8a61a86c665dc30244f41a"
  license "MIT"

  bottle do
    sha256 arm64_tahoe:   "ea9c9802fd2f640ddccc49aaa8c34eb2e33c8943117b90a75124190ead4b5b68"
    sha256 arm64_sequoia: "cd6d6993865411aefd931a0b272f2765533b4d78eecfb71477e0d5817c583e55"
    sha256 arm64_sonoma:  "7aa8c2f1836df5431660e2226e9a56ff327b93dd72810b9d222af9fdd94404a7"
    sha256 sonoma:        "4c361c282a335e34224a8d6518c89b33098513459f64b2ae49bb5354e6c113ea"
    sha256 arm64_linux:   "ca96b6e6edf86efbd0feb77698639cdcc864a516c88a8621fa319a4b37382523"
    sha256 x86_64_linux:  "13a6735d628c69591407d7ffacb6d3dae990ca5b6acdd2ac6e3e856dd0a87063"
  end

  depends_on "cmake" => :build

  uses_from_macos "curl"

  on_macos do
    depends_on "libomp"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
