class Mpv < Formula
  desc "Media player based on MPlayer and mplayer2"
  homepage "https://mpv.io"
  url "https://github.com/mpv-player/mpv/archive/v0.34.1.tar.gz"
  sha256 "32ded8c13b6398310fa27767378193dc1db6d78b006b70dbcbd3123a1445e746"
  license :cannot_represent
  head "https://github.com/mpv-player/mpv.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "a5b475a71a31ad4158fc535872120d0a6ffd4328fc73c1aacf71c97acd75ae1a"
    sha256 arm64_big_sur:  "0fa381a795007043839aa1fea6c8ac09a129a43b45951b32ee7153876b70166b"
    sha256 monterey:       "e0258c0434a62f844135e589d2ba2718095481bb3e0cbc19165c0b389bc106bd"
    sha256 big_sur:        "93c670a01116d34ccddac558f0e94586e61af8f5a5ed32fa257292e82bd99ea2"
    sha256 catalina:       "6ce8b624d2f299bbfa38a8a05e66265e333ea22dc33011714f2747670d84338c"
    sha256 x86_64_linux:   "b7d5900e4a201689c18c79adb4eaf0553ded5d70f3ab52b2c5adbf1c306244ab"
  end

  depends_on "docutils" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.9" => :build
  depends_on xcode: :build

  depends_on "ffmpeg"
  depends_on "jpeg"
  depends_on "libarchive"
  depends_on "libass"
  depends_on "little-cms2"
  depends_on "luajit-openresty"
  depends_on "mujs"
  depends_on "uchardet"
  depends_on "vapoursynth"
  depends_on "yt-dlp"

  def install
    # LANG is unset by default on macOS and causes issues when calling getlocale
    # or getdefaultlocale in docutils. Force the default c/posix locale since
    # that's good enough for building the manpage.
    ENV["LC_ALL"] = "C"

    # libarchive is keg-only
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["libarchive"].opt_lib/"pkgconfig"
    # luajit-openresty is keg-only
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["luajit-openresty"].opt_lib/"pkgconfig"

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
      --lua=luajit
    ]

    system Formula["python@3.9"].opt_bin/"python3", "bootstrap.py"
    system Formula["python@3.9"].opt_bin/"python3", "waf", "configure", *args
    system Formula["python@3.9"].opt_bin/"python3", "waf", "install"
  end

  test do
    system bin/"mpv", "--ao=null", "--vo=null", test_fixtures("test.wav")
    assert_match "vapoursynth", shell_output(bin/"mpv --vf=help")
  end
end
