class Blink1 < Formula
  desc "Control blink(1) indicator light"
  homepage "https://blink1.thingm.com/"
  url "https://github.com/todbot/blink1-tool.git",
      :tag      => "v2.1.0",
      :revision => "6aed8b1c334edcbcff04951db4bba7816ef336f7"
  head "https://github.com/todbot/blink1-tool.git"

  bottle do
    cellar :any
    sha256 "a7443c93dae3d13fef21b814396945d666ff3d32756106b2bc479dbf843e0e72" => :catalina
    sha256 "a7443c93dae3d13fef21b814396945d666ff3d32756106b2bc479dbf843e0e72" => :mojave
    sha256 "7066a0cdd84d176e63e466c742d06e358685e18c6262f55b41d70a4a9a196638" => :high_sierra
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
