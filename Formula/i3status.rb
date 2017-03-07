class I3status < Formula
  desc "Status bar for i3"
  homepage "https://i3wm.org/i3status"
  url "https://i3wm.org/i3status/i3status-2.11.tar.bz2"
  sha256 "98db7e730f0ce908eb656ac10d713ae6a885676621391d54f00b719752f18c5f"
  head "https://github.com/i3/i3status.git"

  bottle do
    cellar :any
    sha256 "3548d5e6f451ffa9c132116d596accae5fd161a546865b8e328b9d83320bcbe5" => :sierra
    sha256 "7e1556c6122b185906d5120b6c4673053ab8f681d230b3f4a26f13801dabafc5" => :el_capitan
    sha256 "abcaacfe2ea691a59ea8b21de3b9e0c8a030a829b02fa254969a302b698553db" => :yosemite
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
