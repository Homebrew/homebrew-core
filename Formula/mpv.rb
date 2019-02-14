class Mpv < Formula
  desc "Media player based on MPlayer and mplayer2"
  homepage "https://mpv.io"
  url "https://github.com/mpv-player/mpv/archive/v0.29.1.tar.gz"
  sha256 "f9f9d461d1990f9728660b4ccb0e8cb5dce29ccaa6af567bec481b79291ca623"
  revision 3
  head "https://github.com/mpv-player/mpv.git"

  bottle do
    sha256 "a91d2f0d616a23d37308c5a0c1f4902b07eec44f2eb6619c285044d3e4bb0124" => :mojave
    sha256 "27b27bc1bfe887f696b5c625dc5ac5dab5806a02cfa6104be1214e1eb6d3ec53" => :high_sierra
    sha256 "61471c7206414f25b4c23da82b239197000d4d94104fdd51e0893e07d44b8737" => :sierra
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
      --enable-zsh-comp
      --zshdir=#{zsh_completion}
    ]

    system "./bootstrap.py"
    system "python3", "waf", "configure", *args
    system "python3", "waf", "install"

    system "python3", "TOOLS/osxbundle.py", "build/mpv"
    prefix.install "build/mpv.app"
  end

  test do
    system bin/"mpv", "--ao=null", test_fixtures("test.wav")
  end
end
