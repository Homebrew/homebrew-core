class Mpv < Formula
  desc "Media player based on MPlayer and mplayer2"
  homepage "https://mpv.io"
  url "https://github.com/mpv-player/mpv/archive/v0.32.0.tar.gz"
  sha256 "9163f64832226d22e24bbc4874ebd6ac02372cd717bef15c28a0aa858c5fe592"
  revision 1
  head "https://github.com/mpv-player/mpv.git"

  bottle do
    sha256 "f54249d632d0e80a5bf8181a2e8a944f8a6e5b12fbbd2f86f1cd9a2e62c760bf" => :catalina
    sha256 "c3a6805d2e6a5140466f07a38add45866b45ac88d5792e1bde82269c8f152f55" => :mojave
    sha256 "bce5f886921c00fac8b731a0090d18b20a4c26b4fcd9550700d3ca6cbf3796f2" => :high_sierra
  end

  depends_on "docutils" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.8" => :build
  depends_on :xcode => :build

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
      --lua=51deb
    ]

    system Formula["python@3.8"].opt_bin/"python3", "bootstrap.py"
    system Formula["python@3.8"].opt_bin/"python3", "waf", "configure", *args
    system Formula["python@3.8"].opt_bin/"python3", "waf", "install"
  end

  test do
    system bin/"mpv", "--ao=null", test_fixtures("test.wav")
  end
end
