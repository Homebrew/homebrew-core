class LtcTools < Formula
  desc "Tools to deal with linear-timecode (LTC)"
  homepage "https://github.com/x42/ltc-tools"
  url "https://github.com/x42/ltc-tools/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "5b7a2ab7f98bef6c99bafbbc5605a3364e01c9c19fe81411ddea0e1a01cd6287"
  license "GPL-2.0-or-later"
  head "https://github.com/x42/ltc-tools.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "ec96e870047e02edacc44e7c436bbe4b818ad675effadfa4c809319594f7eb8b"
    sha256 cellar: :any,                 arm64_sequoia:  "50128bae6264b3239c9d2e8e0f9952e72c364349438382c36f35252c35eedcaa"
    sha256 cellar: :any,                 arm64_sonoma:   "539c3a74d0e1da9b7680063d41e735d3240bd2bb8454b2e93a7c42118b73c147"
    sha256 cellar: :any,                 arm64_ventura:  "bb595fe27ddac376f1ea097a824c17712c34dde20e01cb310388897b52f3f57d"
    sha256 cellar: :any,                 arm64_monterey: "d8d6d714abdb13a7c1a42503b1f367af936975d51454967bb445acb631b58259"
    sha256 cellar: :any,                 arm64_big_sur:  "2131abaab3877ab6a2425fe8b635612c5d7235026d6098a3eea78d266038378a"
    sha256 cellar: :any,                 sonoma:         "3a92ea1ce6d7e1090c583abbab1c5332f1f016d34e7b8932693c7d263e706279"
    sha256 cellar: :any,                 ventura:        "c118c95af01d6294a78e22dcbc2ea901ce5c7bf52a62912895c2ed3c344df105"
    sha256 cellar: :any,                 monterey:       "84e20bc4899a76f661ff8bde1ec354a3d32f6f53b4aa434782095868971a2cc7"
    sha256 cellar: :any,                 big_sur:        "b31fe1140d71357035fd130e73c286d8892cda1103fccd96971205bd860cd9a7"
    sha256 cellar: :any,                 catalina:       "bcd064f64a21f101f6599646306ba65c40ce7ec44fd7b6e2d8f29b4fefeebcc9"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "5cf1b3ebc4b537434144fb06a19917cf47f63f368a6376ad0c78bcc1f42c6695"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f067afb9aec069b45d0c8025574d673d701140d4262ba2530337a868c016bd81"
  end

  depends_on "help2man" => :build
  depends_on "pkgconf" => :build
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
