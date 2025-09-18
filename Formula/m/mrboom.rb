class Mrboom < Formula
  desc "Eight player Bomberman clone"
  homepage "http://mrboom.mumblecore.org/"
  url "https://github.com/Javanaise/mrboom-libretro/releases/download/5.5/MrBoom-src-5.5.tar.gz"
  sha256 "c37c09c30662b17f1c7da337da1475f534674686ce78c7e15b603eeadc4498f0"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "0f75bf0a9e0a7ab7d6a6cdf4b4cc8cbcb4e1a10999900f82819dae07e211cd40"
    sha256 cellar: :any,                 arm64_sequoia:  "de4b659b5cc4e5c3bf4b4aaae71ef0dd18f2796c749d05e46bf888b20a678a54"
    sha256 cellar: :any,                 arm64_sonoma:   "0accb2a0bc974051659e56bcd38d59fbd97d5deee7187341ccfe4c7d97e4a93b"
    sha256 cellar: :any,                 arm64_ventura:  "ee172fbf933602cd8e7000325bdd568c788e6f5a9025dbebe78a44877c5599c4"
    sha256 cellar: :any,                 arm64_monterey: "4ee5323d9f8a79f6657a66d115bee75002a21394dcc24b060e40edbd084be884"
    sha256 cellar: :any,                 sonoma:         "0e9ade944b362e11025baa34ca19d545f8ba6f92668044288fc9b67d6ba0c35b"
    sha256 cellar: :any,                 ventura:        "2eae2f3ed78912724d5518e2e68f4cf96b30461b69c770b413f85564266a5231"
    sha256 cellar: :any,                 monterey:       "928df5b59e0ca8fd75ba6d73643c40a8f1de19be35c251a288dc0e991e2c57df"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "4e01474f0bc6aae305f5ca6bc0f0ed6de99fd70112540185d9d7baec1de89916"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c5d458cb0a2f0ed01cca78bf15db00aa8e4f5750538456bd2024e640da79dc4e"
  end

  depends_on "cmake" => :build
  depends_on "libmodplug"
  depends_on "minizip"
  depends_on "sdl2"
  depends_on "sdl2_mixer"

  def install
    system "make", "mrboom", "LIBSDL2=1"
    system "make", "install", "PREFIX=#{prefix}", "MANDIR=share/man/man6"
  end

  test do
    # mrboom is a GUI application
    assert_match version.to_s, shell_output("#{bin}/mrboom --version")
  end
end
