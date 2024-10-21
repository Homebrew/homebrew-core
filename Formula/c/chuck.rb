class Chuck < Formula
  desc "Concurrent, on-the-fly audio programming language"
  homepage "https://chuck.cs.princeton.edu/"
  url "https://chuck.cs.princeton.edu/release/files/chuck-1.5.3.2.tgz"
  mirror "https://chuck.stanford.edu/release/files/chuck-1.5.3.2.tgz"
  sha256 "7926211292af59f81ce823db9deda981f98c0cf784ab62d3b66c57dfc92f9561"
  license "GPL-2.0-or-later"
  head "https://github.com/ccrma/chuck.git", branch: "main"

  livecheck do
    url "https://chuck.cs.princeton.edu/release/files/"
    regex(/href=.*?chuck[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9fcf2a39d521d4e408451846e552eb0805b1b161a68900fba6b36d31272d6af9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "845a2197850e11934791706e546e19eef0389e5bb333e2da69716939172cc90d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "93127aa767a2e2c2d4ae6270c0b0f53c58237523566501e482768f822ad817ed"
    sha256 cellar: :any_skip_relocation, sonoma:        "942128e70de99ff782d2d689f5b61e3f9efcbc684362f1143552a6ad660e7dc1"
    sha256 cellar: :any_skip_relocation, ventura:       "39c8833c8cdad6f850ba57947dd0a7bd49785dae6a34faf0f5135bc5d205be0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "db7d66cec811e15aab6d0466333703685fa68fa734eb1d6252e7744e88c04860"
  end

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
