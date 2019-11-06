class LtcTools < Formula
  desc "Tools to deal with linear-timecode (LTC)"
  homepage "https://github.com/x42/ltc-tools"
  url "https://github.com/x42/ltc-tools/archive/v0.7.0.tar.gz"
  sha256 "5b7a2ab7f98bef6c99bafbbc5605a3364e01c9c19fe81411ddea0e1a01cd6287"
  head "https://github.com/x42/ltc-tools.git"

  bottle do
    cellar :any
    sha256 "bcd064f64a21f101f6599646306ba65c40ce7ec44fd7b6e2d8f29b4fefeebcc9" => :catalina
    sha256 "ae65212fa593ee7015eb7bfa63b4e7e7691e56a7db0fc1a82a311aef184aae55" => :mojave
    sha256 "15da8efd84adb9d9eb9c7b4450c75e326679b20bed258c8e7011fc6eb2cc9b20" => :high_sierra
    sha256 "51df0ba95565d43955bbdf0cfbc216696b4002f8cc95c80d8f6b387eece034d1" => :sierra
  end

  depends_on "help2man" => :build
  depends_on "pkg-config" => :build
  depends_on "jack"
  depends_on "libltc"
  depends_on "libsndfile"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system bin/"ltcgen", "test.wav"
    system bin/"ltcdump", "test.wav"
  end
end
