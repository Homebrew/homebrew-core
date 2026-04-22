class Ctl < Formula
  desc "Programming language for digital color management"
  homepage "https://github.com/ampas/CTL"
  url "https://github.com/ampas/CTL/archive/refs/tags/ctl-1.5.5.tar.gz"
  sha256 "b6a36ac31e0a79224216e4fc41b56982939cec7a1afd4e80165cec3f1c37d265"
  license "AMPAS"
  head "https://github.com/ampas/CTL.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ca511a0c2b48007131b0582bb71116f5cc0eac17087434738e6f7a6c50397d91"
    sha256 cellar: :any,                 arm64_sequoia: "45d8158cce14a51d6974e9cc1603b88c0329e26c76574ccbeaf9372d687bf05d"
    sha256 cellar: :any,                 arm64_sonoma:  "46d3f74998db9417edb5725421b181e05a11e1a35dbd6cd19aa961a443c7b04c"
    sha256 cellar: :any,                 sonoma:        "29d9deebf5250fa3faa927ce5ee71a4488ea49dd00c595c1f6443006e8106899"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9ec0a75ad70ea5c05ce1165095a98a1a69cf898cf09eb7206c7885e752fb7045"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d035e411659b169fb4d073389599ddb0337c3a5b43cdb088e57496cff47709e"
  end

  depends_on "cmake" => :build
  depends_on "aces_container"
  depends_on "imath"
  depends_on "libtiff"
  depends_on "openexr"

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    "-DCTL_BUILD_TESTS=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match "transforms an image", shell_output("#{bin}/ctlrender -help", 1)
  end
end
