class Mpv < Formula
  desc "Media player based on MPlayer and mplayer2"
  homepage "https://mpv.io"
  url "https://github.com/mpv-player/mpv/archive/v0.21.0.tar.gz"
  sha256 "d05f8ece859c500ef1649cdfea911ec1529df1898b8fda3e217766dc28dc9bd3"
  revision 1
  head "https://github.com/mpv-player/mpv.git"

  bottle do
    sha256 "30e5f30907dfba8a185e009353ab3640e52792a0cf6913faf35e5e45c4b8f28f" => :sierra
    sha256 "a17d0405b9eece2ff7881c7221299dd73ac854e6500702549ae518ca2b0cb328" => :el_capitan
    sha256 "1b9a41055c10faae6a4b6f8939d7c99f6d2cc0b8792920e56233106201d97f6a" => :yosemite
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

  depends_on "libarchive" => :optional
  depends_on "libcaca" => :optional
  depends_on "libdvdread" => :optional
  depends_on "libdvdnav" => :optional
  depends_on "libbluray" => :optional
  depends_on "libaacs" => :optional
  depends_on "vapoursynth" => :optional
  depends_on "uchardet" => :optional
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
