class Mpv < Formula
  desc "Media player based on MPlayer and mplayer2"
  homepage "https://mpv.io"
  url "https://github.com/mpv-player/mpv/archive/v0.20.0.tar.gz"
  sha256 "fe6ec9d2ded5ce84b963f54b812d579d04f944f4a737f3ae639c4d5d9e842b56"
  head "https://github.com/mpv-player/mpv.git"

  bottle do
    rebuild 1
    sha256 "7860cc7b7ca8b8e308d46b242baff6a5d85641e35e654ccfe6e62dfb560d3979" => :sierra
    sha256 "89cda2b8a94622ab29c52ba903ad84164a5ac5c0d212e9ebe22e23f0093b568d" => :el_capitan
    sha256 "556f02d539e927f559e33ceb25436b930bebcfd775e7203062d405e806ae6db9" => :yosemite
    sha256 "96173d039e1ae0329d24a628c8775b02f2c7791190015c650b021d611046d1b7" => :mavericks
  end

  option "with-bundle", "Enable compilation of the .app bundle."

  depends_on "pkg-config" => :build
  depends_on "docutils" => :build
  depends_on :python3

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

  resource "waf" do
    url "https://waf.io/waf-1.9.2"
    sha256 "7abb4fbe61d12b8ef6a3163653536da7ee31709299d8f17400d71a43247cea81"
  end

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

    waf = resource("waf")
    buildpath.install waf.files("waf-#{waf.version}" => "waf")
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
