class Mpv < Formula
  desc "Media player based on MPlayer and mplayer2"
  homepage "https://mpv.io"
  url "https://github.com/mpv-player/mpv/archive/v0.34.0.tar.gz"
  sha256 "f654fb6275e5178f57e055d20918d7d34e19949bc98ebbf4a7371902e88ce309"
  license :cannot_represent
  head "https://github.com/mpv-player/mpv.git"

  bottle do
    sha256 arm64_monterey: "2c87830fd6006e7c418004c5d626da19c8b97fbb6bf6ddb75b13687256fc588d"
    sha256 arm64_big_sur:  "19f656ef91e0c6bcba4201fe3b05f7cc83dda990e519f4dfbda1eaaaab50aa61"
    sha256 monterey:       "7c7cc932e5b424b77b1b88751dc4577f22306f956ddf300d20b85786e6baea69"
    sha256 big_sur:        "d1ddf422792358dd90e072a51c9a9c732ad92259e613589c988ef9e5971d465f"
    sha256 catalina:       "0982bcbef7264efc31d811aa6d6d68dd27e851f8eb405bed612e0bea5244f203"
    sha256 x86_64_linux:   "213a2c9abf0fa5abc4fc9711d09b36b4ca884240dd1bda7bd5ba0074bc87efec"
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
