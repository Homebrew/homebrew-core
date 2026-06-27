class Btdu < Formula
  desc "Sampling disk usage profiler for btrfs"
  homepage "https://github.com/CyberShadow/btdu"
  url "https://github.com/CyberShadow/btdu/archive/refs/tags/v0.7.2.tar.gz"
  sha256 "695ded59fb2029c8ae48ca0f990e68928841cdf36a4cf4cbc2485460cadbbd67"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "e4b116ccc458c661d1a3f72dce44a0f007e1dc7f56a7740e21cb807527e4be80"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "088f46650737b8ca0234cafe7c081b5b3499d92d9984da08d32226d34309d2bd"
  end

  depends_on "btrfs-progs" => :build
  depends_on "dub" => :build
  depends_on "ldc" => :build
  uses_from_macos "ncurses"

  def install
    system "dub", "build", "-b", "release", "--compiler=ldc2"
    bin.install "btdu"
  end

  test do
    # This program requires sudo.
    assert_match "Fatal error: No path specified", shell_output("#{bin}/btdu 2>&1", 1)
  end
end
