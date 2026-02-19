class Nvtop < Formula
  desc "Interactive GPU process monitor"
  homepage "https://github.com/Syllo/nvtop"
  url "https://github.com/Syllo/nvtop/archive/refs/tags/3.3.2.tar.gz"
  sha256 "bfcf24a4bbc763c92a630900f1679f05cce3c9d5f4d1f4a95bdb9230ef562665"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "76ee86ee0c3aff96e54fceceea9fc3ad3df75cb8f31cb9f352f0215abdd33062"
    sha256 cellar: :any,                 arm64_sequoia: "032b3e5a4782ea16ecbb65a91098a8b2790c2e7add4da4befe2ccc4d57b82dc7"
    sha256 cellar: :any,                 arm64_sonoma:  "c7b219158274a2fa35cd72acc752fa03877a9d3f2be6de9652d2a5a43bfafdfa"
    sha256 cellar: :any,                 sonoma:        "2d5113cf560561639cae932298e460da47e07a4ec205be56e8412f83af141262"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "736cd6ffc7e5651becb35246dcecca14ed7a6feca1c52ea3fca4a2c15d31207b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d59233a29922c798943bb0c5706aa7be60ae2237c513b7e926055e9e913062b1"
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
