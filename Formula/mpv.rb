class Mpv < Formula
  desc "Media player based on MPlayer and mplayer2"
  homepage "https://mpv.io"
  url "https://github.com/mpv-player/mpv/archive/v0.31.0.tar.gz"
  sha256 "805a3ac8cf51bfdea6087a6480c18835101da0355c8e469b6d488a1e290585a5"
  head "https://github.com/mpv-player/mpv.git"

  bottle do
    rebuild 1
    sha256 "2b74c106f611b2019ddafd39d8e4d1f2a921c0bf70b2c88ef6f75d8ac74fc4ef" => :catalina
    sha256 "008065b20d49d3b6b758c5343406ff3e81a7fb3eb4bf584e3cccce278f34d428" => :mojave
    sha256 "2065404c51b4f50edc3f6f8859410920d015501c1d74969239b549c1e7e83f4b" => :high_sierra
  end

  depends_on "docutils" => :build
  depends_on "pkg-config" => :build
  depends_on "python" => :build

  depends_on "ffmpeg"
  depends_on "jpeg"
  depends_on "libarchive"
  depends_on "libass"
  depends_on "little-cms2"
  depends_on "lua@5.1"

  depends_on "mujs"
  depends_on "uchardet"
  depends_on "vapoursynth"
  depends_on "youtube-dl"

  def install
    # LANG is unset by default on macOS and causes issues when calling getlocale
    # or getdefaultlocale in docutils. Force the default c/posix locale since
    # that's good enough for building the manpage.
    ENV["LC_ALL"] = "C"

    args = %W[
      --prefix=#{prefix}
      --enable-html-build
      --enable-javascript
      --enable-libmpv-shared
      --enable-lua
      --enable-libarchive
      --enable-uchardet
      --confdir=#{etc}/mpv
      --datadir=#{pkgshare}
      --mandir=#{man}
      --docdir=#{doc}
      --zshdir=#{zsh_completion}
    ]

    system "python3", "bootstrap.py"
    system "python3", "waf", "configure", *args
    system "python3", "waf", "install"
  end

  test do
    system bin/"mpv", "--ao=null", test_fixtures("test.wav")
  end
end
