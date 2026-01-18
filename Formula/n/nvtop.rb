class Nvtop < Formula
  desc "Interactive GPU process monitor"
  homepage "https://github.com/Syllo/nvtop"
  url "https://github.com/Syllo/nvtop/archive/refs/tags/3.3.0.tar.gz"
  sha256 "bc133b3baeb620d3b859aab6238c45de64b8269579b62e544f2ff747d129337e"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "bdeaed767344decc599d0ed011e3b939f4cba54c7ec427843e18a2cef8e6caff"
    sha256 cellar: :any,                 arm64_sequoia: "c1d95b468b04c63fe2effacf9460142e50e09a9ddbaea57b1a7fa933909ca0cc"
    sha256 cellar: :any,                 arm64_sonoma:  "b869a6723082c1adf7625bc25e9bbecd3bcc6ffcfd4e111b105ae41de8103b10"
    sha256 cellar: :any,                 sonoma:        "9551f92829295a680795710d818c935844170a8963b96d19eb423f87c23402f7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "656ec0f61b24cc3707e2edbf714bc612a169fc3c3ee740a03ac71bd72b615185"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "077c483851dd590a4c6e4844e03dbef012001878acc65455d273c557704ecd71"
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
