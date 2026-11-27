class Btdu < Formula
  desc "Sampling disk usage profiler for btrfs"
  homepage "https://github.com/CyberShadow/btdu"
  url "https://github.com/CyberShadow/btdu/archive/refs/tags/v0.7.2.tar.gz"
  sha256 "695ded59fb2029c8ae48ca0f990e68928841cdf36a4cf4cbc2485460cadbbd67"
  license "GPL-2.0-only"

  bottle do
    manifest_sha256 "2c5cd5f6616d68d920b65f9843268bd9651a62dbf66a744aa6c980217da8b433"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "e4b116ccc458c661d1a3f72dce44a0f007e1dc7f56a7740e21cb807527e4be80"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "088f46650737b8ca0234cafe7c081b5b3499d92d9984da08d32226d34309d2bd"
  end

  depends_on "btrfs-progs" => :build
  depends_on "dub" => :build
  depends_on "ldc" => :build
  depends_on :linux
  depends_on "ncurses"

  # Backport ae update to fix build with newer ldc
  patch do
    url "https://github.com/CyberShadow/btdu/commit/882b602b0243e36c9522ec282ce33a0c8b0b1c6a.patch?full_index=1"
    sha256 "92ad3e329538fcb9441aabc0bcaa2d8a1c64782f08b920d208138a7fcd2ae407"
    type :backport
  end

  deny_network_access!

  def fetch
    system "dub", "fetch"
  end

  def install
    system "dub", "build", "-b", "release", "--compiler=ldc2"
    bin.install "btdu"
  end

  test do
    # This program requires sudo.
    assert_match "Fatal error: No path specified", shell_output("#{bin}/btdu 2>&1", 1)
  end
end
