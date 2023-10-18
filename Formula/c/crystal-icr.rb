class CrystalIcr < Formula
  desc "Interactive console for Crystal programming language"
  homepage "https://github.com/crystal-community/icr"
  url "https://github.com/crystal-community/icr/archive/v0.9.0.tar.gz"
  sha256 "2530293e94b60d69919a79b49e83270f1462058499ad37a762233df8d6e5992c"
  license "MIT"
  revision 2

  bottle do
    sha256 arm64_sonoma:   "c20524531eb331ee159bcb097d64ef72e9f3a22964ce5c8f21b9eff74734da3b"
    sha256 arm64_ventura:  "edde5bd51d5bb2b03570b20e45ebc53ce09832920f75a3e50cbac956f661c215"
    sha256 arm64_monterey: "bc8b1981630d79dc3e135ad87f1ddedee260a92c1a5a19b31fc681fe2b596ad4"
    sha256 arm64_big_sur:  "13ef5cc2c563f77416cb551e301c9819e3948f736828fe87129f8a24bfebe399"
    sha256 sonoma:         "fde1cf609f157925e76e67d4fb7e9730d9c06e820df68d52cd7c68932893683d"
    sha256 ventura:        "72683ff057900f8a0a07858f0b1087674c535897c4e6f43faadd4675f658e4af"
    sha256 monterey:       "10adec2a41f666a46c7e1095b95f8d3016dbf11f4087a1e222b69f3f18658041"
    sha256 big_sur:        "7e4e298588d34c599657ef4d62d2fe4e44e5ec80a982b656eba12b2d7c8e416a"
    sha256 x86_64_linux:   "d348dfeedacb2bb47173d3435fabe2862281d072bbe706ba00ef7a92e79520d1"
  end

  depends_on "crystal"
  depends_on "libevent"
  depends_on "libyaml"
  depends_on "openssl@3"
  depends_on "readline"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match "icr version #{version}", shell_output("#{bin}/icr -v")
  end
end
