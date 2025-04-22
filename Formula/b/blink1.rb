class Blink1 < Formula
  desc "Control blink(1) indicator light"
  homepage "https://blink1.thingm.com/"
  url "https://github.com/todbot/blink1-tool.git",
      tag:      "v2.3.0",
      revision: "69561a9ed9e83ff67c95cc70187c394150f51cd5"
  license "CC-BY-SA-3.0"
  head "https://github.com/todbot/blink1-tool.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "2b04cc8a396b2f1d9ac01c7558fc56fc27b72792cb148f686e87298c638f29d8"
    sha256 cellar: :any,                 arm64_sonoma:   "6087adc4630ab9c242a9e2c89ce806ba069b9668fa2d19b270a94fd8f9c448fe"
    sha256 cellar: :any,                 arm64_ventura:  "12acc8c268141ffab31dd4e748d99e157d3c6708924aa06cee2afe6da3cbf576"
    sha256 cellar: :any,                 arm64_monterey: "6aaa7efbcc86913250293edca2410848c30e01bf1e0ef70efd798fcd9c893ca8"
    sha256 cellar: :any,                 arm64_big_sur:  "9e57a3c3f96ad7a97056aebfeadb075a5471fe43fa078f4e7f02fdebc3582979"
    sha256 cellar: :any,                 sonoma:         "aa578663e46f8a7c9ab81195093a3bc3ab0ec33e751a0df894bf6309f23a1206"
    sha256 cellar: :any,                 ventura:        "e6fca6c6f10af9f3233262e7dd50f0a126f73c49288f0f27db5e4e4365bacdc3"
    sha256 cellar: :any,                 monterey:       "23bc96b6e6a9b1e9b0abdacc11033c85cd680a7ca3fc51836ebaadeb0e4be373"
    sha256 cellar: :any,                 big_sur:        "dfbcb34a56386bd9ce68d770bfe3355c408ed0d93197f1f07da69e53312b01c8"
    sha256 cellar: :any,                 catalina:       "52a3d5efa444acbd4fe4a76ba38152513bdbfa7138d66e799401aeb0ac87af78"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "7af7689b8df9e9719d45fd5bdd736c515445a476d1c3c50c7e219132e6fff6b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "947b96287a04a1ee9fbe4dd3e0316e084a3cb54a73dbeb411f59959c991dabc4"
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
