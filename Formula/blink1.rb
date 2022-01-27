class Blink1 < Formula
  desc "Control blink(1) indicator light"
  homepage "https://blink1.thingm.com/"
  url "https://github.com/todbot/blink1-tool.git",
      tag:      "v2.3.0",
      revision: "69561a9ed9e83ff67c95cc70187c394150f51cd5"
  license "CC-BY-SA-3.0"
  head "https://github.com/todbot/blink1-tool.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_monterey: "0edd4b1388d7fc0a779bfe546d3ea35537f04e6c5161f16015a604ea31255477"
    sha256 cellar: :any, arm64_big_sur:  "889f3e102d43f059049cec76aa5b80bb099add9927f1bd7d29f7decaa4009741"
    sha256 cellar: :any, monterey:       "1f42d94401931ac01d662006c16df3cc0ac8649264af6ff595ceabda6d0b04bd"
    sha256 cellar: :any, big_sur:        "14af896b923b60092a1bf250dc4e048e7b0fe2c6cd1d503f9b6b90a49e04acff"
    sha256 cellar: :any, catalina:       "1f6cd75723e3fd2ae1620da782c237b4193bb89c6b594e0e5518cea7acebbef3"
    sha256 cellar: :any, mojave:         "f4dba39b59bba805cef467d468f03e927583b97979786357d0ceb32683955491"
  end

  def install
    system "make"
    bin.install "blink1-tool"
    lib.install "libBlink1.dylib"
    include.install "blink1-lib.h"
  end

  test do
    system bin/"blink1-tool", "--version"
  end
end
