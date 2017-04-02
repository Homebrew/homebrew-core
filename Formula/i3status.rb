class I3status < Formula
  desc "Status bar for i3"
  homepage "https://i3wm.org/i3status"
  url "https://i3wm.org/i3status/i3status-2.11.tar.bz2"
  sha256 "98db7e730f0ce908eb656ac10d713ae6a885676621391d54f00b719752f18c5f"
  head "https://github.com/i3/i3status.git"

  bottle do
    cellar :any
    sha256 "f9669cc65b7e4812786ff2f62e11921736898d1fe61dd15b52e0f475ef8d3375" => :sierra
    sha256 "cc0b748443c7977bd647b2a612ea3a94d47feafc3b7f63bb1c67804d44b8c196" => :el_capitan
    sha256 "af64dc8d801c8938e5f1d120f37c5086f9259ad0eeee83937d3cfdf426f801cf" => :yosemite
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
