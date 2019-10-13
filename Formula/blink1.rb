class Blink1 < Formula
  desc "Control blink(1) indicator light"
  homepage "https://blink1.thingm.com/"
  url "https://github.com/todbot/blink1-tool.git",
      :tag      => "v2.0.5",
      :revision => "ab2230d1164020f92cea4b7071e3b3ab4b320421"
  head "https://github.com/todbot/blink1-tool.git"

  bottle do
    cellar :any
    sha256 "a2846d908090afcb7263f40ad7417c075a1d410434daef733e3891880ffa65ff" => :mojave
    sha256 "e653c071bae006ae27f1452f7f824529ca43a8adfe04412020999371a2d64983" => :high_sierra
    sha256 "35d89ca09af8184a60a70b83fb41a88f436463ecb4f0461e6f91b8cd04770075" => :sierra
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
