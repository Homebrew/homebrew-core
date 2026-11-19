class Blink1 < Formula
  desc "Control blink(1) indicator light"
  homepage "https://blink1.thingm.com/"
  url "https://github.com/todbot/blink1-tool.git",
      tag:      "v2.6.0",
      revision: "74db9b7acfb4666b6afc5dab830779845112b1ea"
  license any_of: ["CC-BY-SA-4.0", "MIT"]
  head "https://github.com/todbot/blink1-tool.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "ded75f815d21e15b58bc190aa257ef612745506995a48ed0020b00b796d08b69"
    sha256 cellar: :any, arm64_tahoe:       "3849d109c823ea23cfff8df0362c3afbf0026e9f8247595f5462c6193be1f3e7"
    sha256 cellar: :any, arm64_sequoia:     "3665d4f6069451920e6b98a2e6b8de14759a6806abfdb06d4e73b9ac969b8dec"
    sha256 cellar: :any, arm64_linux:       "7b95430bfb1997473cc5f99cf877a5d5281bac0c2dce0806f868efb7f2aa2929"
    sha256 cellar: :any, x86_64_linux:      "3ed191460cd478a634be44b0276ec964b38b6756b7f83728ed212e7657ebc33c"
  end

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "systemd"
  end

  def install
    mkdir_p [bin, include, lib/"pkgconfig"]
    system "make"
    system "make", "install", "install-dev", "PREFIX=#{prefix}"
  end

  test do
    system bin/"blink1-tool", "--version"
  end
end
