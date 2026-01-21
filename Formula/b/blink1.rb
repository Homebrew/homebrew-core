class Blink1 < Formula
  desc "Control blink(1) indicator light"
  homepage "https://blink1.thingm.com/"
  url "https://github.com/todbot/blink1-tool.git",
      tag:      "v2.4.0",
      revision: "c0d145b55af30135cfcb161cb63267d591143d69"
  license "CC-BY-SA-3.0"
  head "https://github.com/todbot/blink1-tool.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d1ac7aaa3855a99d360f2884e59b4662dd398fd3240d2a6f247764f4468f6f53"
    sha256 cellar: :any,                 arm64_sequoia: "2c6519268e947a70cd5dc1d33ce0e0b8605807537cebcb97ef2d7b0d177014a5"
    sha256 cellar: :any,                 arm64_sonoma:  "b110ab0405453732b655ff9efe92fbfcb99050ca9ca2f462387228e223cf9b84"
    sha256 cellar: :any,                 sonoma:        "40fa9e8de27f1760fc30e89ec9aac8292ec38f3101e48ee795de323e64d3d138"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "55795035b5ab8d7b87698d3aaafe2acb9ef8c1fbb6215677259f92c2a4478bb1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "040a75103d64cc9ada264ea012553afe3f287cb91128373fabde2b0059a94d06"
  end

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "systemd"
  end

  def install
    system "make"
    bin.install "blink1-tool"
    include.install "blink1-lib.h"
    library = OS.mac? ? "libBlink1.dylib" : "libblink1.so"
    lib.install library
  end

  test do
    system bin/"blink1-tool", "--version"
  end
end
