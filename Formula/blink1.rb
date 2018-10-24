class Blink1 < Formula
  desc "Control blink(1) indicator light"
  homepage "https://blink1.thingm.com/"
  url "https://github.com/todbot/blink1-tool.git",
      :tag => "v2.0.1",
      :revision => "56b90c343fee63d15ad24e33c06def588acaad5f"
  head "https://github.com/todbot/blink1-tool.git"

  bottle do
    cellar :any
    sha256 "ed834600464996f4c36f4846e0365b354bb45a67c8c588804945785eb669fcc1" => :mojave
    sha256 "1a564fd8d39f13eea303f2e7f2a59fcd1332fb7b8468ad87b6f76c468cc92253" => :high_sierra
    sha256 "071313e690a4534af8123082c28d0c15a31876c892a3ca3f243210f56b3caef2" => :sierra
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
