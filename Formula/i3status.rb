class I3status < Formula
  desc "Status bar for i3"
  homepage "https://i3wm.org/i3status"
  url "https://i3wm.org/i3status/i3status-2.11.tar.bz2"
  sha256 "98db7e730f0ce908eb656ac10d713ae6a885676621391d54f00b719752f18c5f"
  revision 2
  head "https://github.com/i3/i3status.git"

  bottle do
    cellar :any
    sha256 "09050200d7660dcb5ab2b99684dd406978abf7738e609beeceec4cbef0761a6f" => :sierra
    sha256 "cfd08ff2e313ae35000904e9f3e8c7d471f781578b9b899d6f9bd8ccc225748e" => :el_capitan
    sha256 "b5f41db83b1b1f6b000b8de9e4499b2dffba1ceca33edbb9635d671d223ffbe8" => :yosemite
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
