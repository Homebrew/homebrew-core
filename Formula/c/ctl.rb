class Ctl < Formula
  desc "Programming language for digital color management"
  homepage "https://github.com/aces-aswf/CTL"
  url "https://github.com/aces-aswf/CTL/archive/refs/tags/ctl-1.5.5.tar.gz"
  sha256 "b6a36ac31e0a79224216e4fc41b56982939cec7a1afd4e80165cec3f1c37d265"
  license "AMPAS"
  head "https://github.com/aces-aswf/CTL.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "47ab02f6566688c853c02238bcbd7eb1c625c58ec5715a10699ec2d3254f968b"
    sha256 cellar: :any, arm64_sequoia: "cae61bd17827cf4258fd0ed62d3b0cc4c1e5f225cdcefd0f93d1f2714f9ed2ba"
    sha256 cellar: :any, arm64_sonoma:  "ae55a5403c29344467d027fbe63f833d239c25a8e98a866bb1bbbb5289d4a0cd"
    sha256 cellar: :any, sonoma:        "b992a7caddeacea47fe70eac3a6472a0469182352049d12df3505d17ada69eef"
    sha256 cellar: :any, arm64_linux:   "d81b51797f7a0d4924d4a25718f98140e11f0fda57f39264fc8d79df9885b990"
    sha256 cellar: :any, x86_64_linux:  "ccf4269d792537b2a2af10e3c4c1afb6ee37ffd97038e0583713ba20941765be"
  end

  depends_on "cmake" => :build
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
