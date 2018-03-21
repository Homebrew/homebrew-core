class I3status < Formula
  desc "Status bar for i3"
  homepage "https://i3wm.org/i3status"
  url "https://i3wm.org/i3status/i3status-2.11.tar.bz2"
  sha256 "98db7e730f0ce908eb656ac10d713ae6a885676621391d54f00b719752f18c5f"
  revision 3
  head "https://github.com/i3/i3status.git"

  bottle do
    cellar :any
    sha256 "84e266369b0e59fbb5cb293c340a20773a81079ea80e484b5ecb5bbc6b03875b" => :high_sierra
    sha256 "8044ac2d7c39945c3ca02cb943e485333351080c5f12c421f7d87ea0c877bc74" => :sierra
    sha256 "af7fa1f5913eaaa9f824fa5f11e50523d474473d034d91712b9cf18bb1a56b5f" => :el_capitan
  end

  depends_on :x11
  depends_on "yajl"
  depends_on "confuse"
  depends_on "pulseaudio"
  depends_on "asciidoc" => :build
  depends_on "i3"

  def install
    system "make", "A2X_FLAGS=--no-xmllint"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    result = shell_output("#{bin}/i3status -v")
    result.force_encoding("UTF-8") if result.respond_to?(:force_encoding)
    assert_match version.to_s, result
  end
end
