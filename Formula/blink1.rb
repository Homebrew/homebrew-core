class Blink1 < Formula
  desc "Control blink(1) indicator light"
  homepage "https://blink1.thingm.com/"
  url "https://github.com/todbot/blink1-tool.git",
      :tag => "v2.0.1",
      :revision => "56b90c343fee63d15ad24e33c06def588acaad5f"
  head "https://github.com/todbot/blink1-tool.git"

  bottle do
    cellar :any
    sha256 "4aef741b64215b16bb51483efd8a7a17f4cdfba14c266b820e17c7e536314e03" => :high_sierra
    sha256 "6ece9848387309cce4fa52d91600ea4ab28dc4fcc2564f8883672eb5d56ec45f" => :sierra
    sha256 "707f84ee9c301ff3f3736ed5a4b0decba0533caa115241f43118839c445c7278" => :el_capitan
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
