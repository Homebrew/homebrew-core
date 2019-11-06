class Mpv < Formula
  desc "Media player based on MPlayer and mplayer2"
  homepage "https://mpv.io"
  url "https://github.com/mpv-player/mpv/archive/v0.30.0.tar.gz"
  sha256 "33a1bcb7e74ff17f070e754c15c52228cf44f2cefbfd8f34886ae81df214ca35"
  head "https://github.com/mpv-player/mpv.git"

  bottle do
    sha256 "a6126ab264bbe4f59cc8f27fbaba953a6654943f50c7869a42c74646baa44084" => :catalina
    sha256 "876809a4bbe6af6f5dce055a7c7246b0b48db9237b6a7ba0151ef3b17eb2e1d8" => :mojave
    sha256 "fc82056229104bf1898040d8cfd01eafa3a86afa18cdb0a1776afb63f0d72e7d" => :high_sierra
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

    system "./bootstrap.py"
    system "python3", "waf", "configure", *args
    system "python3", "waf", "install"
  end

  test do
    system bin/"mpv", "--ao=null", test_fixtures("test.wav")
  end
end
