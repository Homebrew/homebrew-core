class Chuck < Formula
  desc "Concurrent, on-the-fly audio programming language"
  homepage "https://chuck.cs.princeton.edu/"
  url "https://chuck.cs.princeton.edu/release/files/chuck-1.4.2.0.tgz"
  mirror "http://chuck.stanford.edu/release/files/chuck-1.4.2.0.tgz"
  sha256 "848c2c0bdad88175924c5a94b9f286aa84f41a7b1fe27478290d224956e3f318"
  license "GPL-2.0-or-later"
  head "https://github.com/ccrma/chuck.git", branch: "main"

  livecheck do
    url "https://chuck.cs.princeton.edu/release/files/"
    regex(/href=.*?chuck[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5359fbc083244b9313209a0f14fdf92ba8e6ee3f617b31d9588d03acc1f2cb5b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5359fbc083244b9313209a0f14fdf92ba8e6ee3f617b31d9588d03acc1f2cb5b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0e46dab3127e31ae27bbefab004bfea849cd59de18b1d96e3c783974c3dffbb0"
    sha256 cellar: :any_skip_relocation, ventura:        "83e0e5081d350088bdba87730810e58823accd1e604afa9eb7c7d055ea99bcb3"
    sha256 cellar: :any_skip_relocation, monterey:       "83e0e5081d350088bdba87730810e58823accd1e604afa9eb7c7d055ea99bcb3"
    sha256 cellar: :any_skip_relocation, big_sur:        "249b1344a43ab50dab69145b9094b5ef2297964e0b7f21198669546da6240d0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6df0db29c35b41fa77e987fcd982cea3c0ba60ce48f4ee675e8f501f4a843064"
  end

  depends_on xcode: :build

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  on_linux do
    depends_on "alsa-lib"
    depends_on "pulseaudio"
  end

  def install
    os = OS.mac? ? "mac" : "linux-pulse"
    system "make", "-C", "src", os
    bin.install "src/chuck"
    pkgshare.install "examples"
  end

  test do
    assert_match "device", shell_output("#{bin}/chuck --probe 2>&1")
  end
end
