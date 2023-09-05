class Avra < Formula
  desc "Assembler for the Atmel AVR microcontroller family"
  homepage "https://github.com/Ro5bert/avra"
  url "https://github.com/Ro5bert/avra/archive/1.4.2.tar.gz"
  sha256 "cc56837be973d1a102dc6936a0b7235a1d716c0f7cd053bf77e0620577cff986"
  license "GPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e1534538fee5207f6bae424a84ecf108e7c0100c513a853b777b817f6baa5e89"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "875e98a908da8ed0978f4b7e3854579dc63dc821df67c924e4ce12c5cd194a0e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "22a03e978b90b0c87a7a7d15f63975880a8bad314c2592bf107b7bcb3d5fe5c6"
    sha256 cellar: :any_skip_relocation, ventura:        "d1df06956805a9e7e69e5a4057535dfffa974f782637f26f92a4000e7c1f0c29"
    sha256 cellar: :any_skip_relocation, monterey:       "af3758871e939781a5bb4842caf21fe8db90dd2f86e3b6b08a5ce49ac00a7f86"
    sha256 cellar: :any_skip_relocation, big_sur:        "b1b6077185e775675dfd538ee67fab94c5e24219dd8cd76b1dbc962748572513"
    sha256 cellar: :any_skip_relocation, catalina:       "752edb7e9140387d4b763229ff05cdf973056a70c5a4799b63cce83c2ff18be5"
    sha256 cellar: :any_skip_relocation, mojave:         "cedf5547712134c47d3659e1cddde7d506643448eca98fb428734165fbb5afc7"
    sha256 cellar: :any_skip_relocation, high_sierra:    "f380ed5ddc18ece7b83f4c32290f56dfcc8a27065cc1a39423debfc482d369d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "db5dc219fb53c28e191c9f2a4127efe2de53a27e7526b2b0d6b705c4ff57ee69"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    system "make", "install", "PREFIX=#{prefix}", "OS=osx"
    pkgshare.install Dir["includes/*"]
  end

  test do
    (testpath/"test.asm").write " .device attiny10\n ldi r16,0x42\n"
    output = shell_output("#{bin}/avra -l test.lst test.asm")
    assert_match "Assembly complete with no errors.", output
    assert_predicate testpath/"test.hex", :exist?
    assert_match "ldi r16,0x42", File.read("test.lst")
  end
end
