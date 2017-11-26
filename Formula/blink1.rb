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
    sha256 "cd4dfb706dc89b0f2dd4809ae0950bc8544e5ec84a11ded657ae34dac2ba0560" => :high_sierra
    sha256 "a5f2a3f5acae040bfc697ee9c23b16d522ecc326bd7c5b74c846dd6922b7175a" => :sierra
    sha256 "227e1fce1bcd3f50cb39231e8ec0e0638b068f68433a12c8a3bac8adfa90961c" => :el_capitan
    sha256 "1536128c6ba6957f3d5f287ab4e0fcc28053ca54604f0ffae06eef2f96c4da88" => :yosemite
    sha256 "1bba2becfb93f831b91654400827acad41de00c2fcfe45b5ca14336fa3545cfd" => :mavericks
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
