class Blink1 < Formula
  desc "Control blink(1) indicator light"
  homepage "https://blink1.thingm.com/"
  url "https://github.com/todbot/blink1-tool.git",
      :tag      => "v2.0.3",
      :revision => "8a6503846da3bd4ca342674b07ae7dc3df8c2f88"
  head "https://github.com/todbot/blink1-tool.git"

  bottle do
    cellar :any
    sha256 "6a9aae3733db387dfa9e9c1bbacb9b3c7993f42486115254c8c67d9c716c455d" => :mojave
    sha256 "0a19927c5f385f1aede59f406edc34d91cfa46b0b961d1f02bf7170e06888f4f" => :high_sierra
    sha256 "9cc48de0d254d4e30d2ac0649d298e55ef0576b97da7b77f170261b9a913da43" => :sierra
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
