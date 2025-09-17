class Nvtop < Formula
  desc "Interactive GPU process monitor"
  homepage "https://github.com/Syllo/nvtop"
  url "https://github.com/Syllo/nvtop/archive/refs/tags/3.2.0.tar.gz"
  sha256 "d26df685455023cedc4dda033862dcddb67402fbdb685da70da78492f73c41d0"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3a65819fce8a84ff3a8a60fe8e46deb4a62e20617560307b23b24998730ce415"
    sha256 cellar: :any,                 arm64_sequoia: "d327c8084394f866b030d090a70cf2873d3fc5be34a49ee17e8f0d5261704289"
    sha256 cellar: :any,                 arm64_sonoma:  "7166164de3da0785848dbd34ceb6168bdcb0b8bf1ec2c7bbcf164884b96a3fbe"
    sha256 cellar: :any,                 arm64_ventura: "77a4d9add58013fbecaae97c280f72e254a02b470f8181d405a80adb4764b435"
    sha256 cellar: :any,                 sonoma:        "29ea0fd9d87ee2f1e9e7cc6b9c6569f19d675346e842df3224a5761b1926c784"
    sha256 cellar: :any,                 ventura:       "e4b5532744457331e345ba2236c284655499881e91d4627b9e3cf480b1af4f49"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "067c3bc059ebd070d62abcc594a0e390587b6e37ca122ef384129347f95da546"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f75c62d6bc039a39e81eb04dbb4b0ba8f95ec6d4f2ba3c6dd1fc3a105cca847"
  end

  depends_on "cmake" => :build
  uses_from_macos "ncurses"

  on_linux do
    depends_on "libdrm"
    depends_on "systemd"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # nvtop is a TUI application
    assert_match version.to_s, shell_output("#{bin}/nvtop --version")
  end
end
