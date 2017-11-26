class Blink1 < Formula
  desc "Control blink(1) indicator light"
  homepage "https://blink1.thingm.com/"
  url "https://github.com/todbot/blink1.git",
      :tag => "v1.98a",
      :revision => "de6c0a951af253cb4827604ef3ae89b1643efe28"
  version "1.98a"
  head "https://github.com/todbot/blink1.git"

  bottle do
    cellar :any
    sha256 "4aef741b64215b16bb51483efd8a7a17f4cdfba14c266b820e17c7e536314e03" => :high_sierra
    sha256 "6ece9848387309cce4fa52d91600ea4ab28dc4fcc2564f8883672eb5d56ec45f" => :sierra
    sha256 "707f84ee9c301ff3f3736ed5a4b0decba0533caa115241f43118839c445c7278" => :el_capitan
  end

  def install
    cd "commandline" do
      system "make"
      bin.install "blink1-tool"
      lib.install "libBlink1.dylib"
      include.install "blink1-lib.h"
    end
  end

  test do
    system bin/"blink1-tool", "--version"
  end
end
