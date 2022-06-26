class LtcTools < Formula
  desc "Tools to deal with linear-timecode (LTC)"
  homepage "https://github.com/x42/ltc-tools"
  url "https://github.com/x42/ltc-tools/archive/v0.7.0.tar.gz"
  sha256 "5b7a2ab7f98bef6c99bafbbc5605a3364e01c9c19fe81411ddea0e1a01cd6287"
  license "GPL-2.0"
  head "https://github.com/x42/ltc-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "d8d6d714abdb13a7c1a42503b1f367af936975d51454967bb445acb631b58259"
    sha256 cellar: :any,                 arm64_big_sur:  "2131abaab3877ab6a2425fe8b635612c5d7235026d6098a3eea78d266038378a"
    sha256 cellar: :any,                 monterey:       "84e20bc4899a76f661ff8bde1ec354a3d32f6f53b4aa434782095868971a2cc7"
    sha256 cellar: :any,                 big_sur:        "b31fe1140d71357035fd130e73c286d8892cda1103fccd96971205bd860cd9a7"
    sha256 cellar: :any,                 catalina:       "bcd064f64a21f101f6599646306ba65c40ce7ec44fd7b6e2d8f29b4fefeebcc9"
    sha256 cellar: :any,                 mojave:         "ae65212fa593ee7015eb7bfa63b4e7e7691e56a7db0fc1a82a311aef184aae55"
    sha256 cellar: :any,                 high_sierra:    "15da8efd84adb9d9eb9c7b4450c75e326679b20bed258c8e7011fc6eb2cc9b20"
    sha256 cellar: :any,                 sierra:         "51df0ba95565d43955bbdf0cfbc216696b4002f8cc95c80d8f6b387eece034d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f067afb9aec069b45d0c8025574d673d701140d4262ba2530337a868c016bd81"
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
