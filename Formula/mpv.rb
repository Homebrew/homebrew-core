class Mpv < Formula
  desc "Media player based on MPlayer and mplayer2"
  homepage "https://mpv.io"
  url "https://github.com/mpv-player/mpv/archive/v0.32.0.tar.gz"
  sha256 "9163f64832226d22e24bbc4874ebd6ac02372cd717bef15c28a0aa858c5fe592"
  revision 4
  head "https://github.com/mpv-player/mpv.git"

  bottle do
    sha256 "2d876a83a16151f8e820a466905b3c1eca6a3e4cf340b3fefe77ed269006da9f" => :catalina
    sha256 "88c3537f6820033349f954bb3f1d4a6b04d8dbdc49a4c90f51a1b3deacc83f65" => :mojave
    sha256 "a50cb9ef8311708303761b82a39c42d3b6d605f1a60eb9798cde1632a4dc494d" => :high_sierra
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
  depends_on "youtube-dl"

  def install
    # LANG is unset by default on macOS and causes issues when calling getlocale
    # or getdefaultlocale in docutils. Force the default c/posix locale since
    # that's good enough for building the manpage.
    ENV["LC_ALL"] = "C"

    # libarchive is keg-only
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["libarchive"].opt_lib/"pkgconfig"

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
