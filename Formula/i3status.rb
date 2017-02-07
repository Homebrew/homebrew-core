class I3status < Formula
  desc "Status bar for i3"
  homepage "http://i3wm.org/i3status"
  head "https://github.com/i3/i3status.git"

  stable do
    url "http://i3wm.org/i3status/i3status-2.10.tar.bz2"
    sha256 "daf5d07611b054a43da1a3d28850b05e2dbdbd6d25fd5e25ede98bb1b66e2791"

    # NOTE: Remove the patches on the next release, since they have been reported and merged upstream
    # Add ifdef to compile wireless_info on Mac
    patch do
      url "https://github.com/i3/i3status/commit/0a2d4d8a04dcfa71f9e8cecb2bd2772df989b228.patch"
      sha256 "f183f05f9295d420a13dee0afbb7a9781216da13c88c8568e49dbfdadf958b64"
    end
  end
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
