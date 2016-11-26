class Mpv < Formula
  desc "Media player based on MPlayer and mplayer2"
  homepage "https://mpv.io"
  url "https://github.com/mpv-player/mpv/archive/v0.22.0.tar.gz"
  sha256 "c0f9ac8f0e37a391d19007b333ef8787c2f45d75a0d4401c0098cde52c5082f6"
  revision 1

  head "https://github.com/mpv-player/mpv.git"

  bottle do
    sha256 "dcc8a25efd4c74d5cb619af8651399239cc93f4039c5c88965c208be9473b1a5" => :sierra
    sha256 "8610d4db3500053a10c41a954a902b4001ffe5821a15c4dbf45975b1b200e838" => :el_capitan
    sha256 "9d0516238bf40e6760afbbeed87f4069c2ca9a49a30c4f14cc9472c8ecc0609f" => :yosemite
  end

  option "with-bundle", "Enable compilation of the .app bundle."

  depends_on "pkg-config" => :build
  depends_on "docutils" => :build
  depends_on :python3 => :build

  depends_on "libass"
  depends_on "ffmpeg"

  depends_on "jpeg" => :recommended
  depends_on "little-cms2" => :recommended
  depends_on "lua" => :recommended
  depends_on "youtube-dl" => :recommended

  depends_on "jack" => :optional
  depends_on "libaacs" => :optional
  depends_on "libarchive" => :optional
  depends_on "libbluray" => :optional
  depends_on "libcaca" => :optional
  depends_on "libdvdnav" => :optional
  depends_on "libdvdread" => :optional
  depends_on "pulseaudio" => :optional
  depends_on "rubberband" => :optional
  depends_on "uchardet" => :optional
  depends_on "vapoursynth" => :optional
  depends_on :x11 => :optional

  depends_on :macos => :mountain_lion

  def install
    # LANG is unset by default on osx and causes issues when calling getlocale
    # or getdefaultlocale in docutils. Force the default c/posix locale since
    # that's good enough for building the manpage.
    ENV["LC_ALL"] = "C"

    args = %W[
      --prefix=#{prefix}
      --enable-zsh-comp
      --enable-libmpv-shared
      --confdir=#{etc}/mpv
      --datadir=#{pkgshare}
      --mandir=#{man}
      --docdir=#{doc}
      --zshdir=#{zsh_completion}
    ]
    args << "--enable-libarchive" if build.with? "libarchive"
    args << "--enable-pulse" if build.with? "pulseaudio"

    system "./bootstrap.py"
    system "python3", "waf", "configure", *args
    system "python3", "waf", "install"

    if build.with? "bundle"
      system "python3", "TOOLS/osxbundle.py", "build/mpv"
      prefix.install "build/mpv.app"
    end
  end

  test do
    system bin/"mpv", "--ao=null", test_fixtures("test.wav")
  end
end
