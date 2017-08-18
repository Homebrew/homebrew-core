class I3status < Formula
  desc "Status bar for i3"
  homepage "https://i3wm.org/i3status"
  url "https://i3wm.org/i3status/i3status-2.11.tar.bz2"
  sha256 "98db7e730f0ce908eb656ac10d713ae6a885676621391d54f00b719752f18c5f"
  revision 2
  head "https://github.com/i3/i3status.git"

  bottle do
    cellar :any
    sha256 "109cf545c41a93607a72fe507e0da22a8ad0fdcea41c7493a8f825286acf1f4f" => :sierra
    sha256 "5d2fb48e3a6d74b7a1426986efff59b05688b408630fbba1cdd3b8970c5f3eb9" => :el_capitan
    sha256 "b81096aac3d8c989d22d670643ad00c74f531f17e9b6dcba4113f1890a4ce3fc" => :yosemite
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
