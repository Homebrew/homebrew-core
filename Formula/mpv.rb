class Mpv < Formula
  desc "Media player based on MPlayer and mplayer2"
  homepage "https://mpv.io"
  url "https://github.com/mpv-player/mpv/archive/v0.34.0.tar.gz"
  sha256 "f654fb6275e5178f57e055d20918d7d34e19949bc98ebbf4a7371902e88ce309"
  license :cannot_represent
  head "https://github.com/mpv-player/mpv.git"

  bottle do
    sha256 arm64_monterey: "c3ef442c5e83fd6540a01fc6376c5cade89b7bd5f07abf7811f1a06fdc664d81"
    sha256 arm64_big_sur:  "dd487a80e5586c93ccde6942170d026e9eba5b403d95e409ad55282cea818790"
    sha256 monterey:       "48cff8a1e5ce3e63982e586a114d3ebee3d689e8bd5b23ad1db78323c1e088b0"
    sha256 big_sur:        "76b0fc9d207aee16f65b8b1782bc35dec5a870952ebba6ae7a74e6ede9bdd34a"
    sha256 catalina:       "8ab98fffc330dea03f2732fa17c7f53753601c49c3f9dec2a7d727bdc901c484"
    sha256 mojave:         "87df95e8f4f723a5b6fe163d5ac740fef9f5ffa9c318c82c9a6b0844aa7203b9"
    sha256 x86_64_linux:   "6a037de38402f73783c5b403e6aada7388373eda6593b21e43844043cf6496d6"
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
  depends_on "youtube-dl"

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
    system bin/"mpv", "--ao=null", test_fixtures("test.wav")
    assert_match "vapoursynth", shell_output(bin/"mpv --vf=help")
  end
end
