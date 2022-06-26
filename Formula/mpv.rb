class Mpv < Formula
  desc "Media player based on MPlayer and mplayer2"
  homepage "https://mpv.io"
  url "https://github.com/mpv-player/mpv/archive/v0.34.1.tar.gz"
  sha256 "32ded8c13b6398310fa27767378193dc1db6d78b006b70dbcbd3123a1445e746"
  license :cannot_represent
  revision 1
  head "https://github.com/mpv-player/mpv.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "09e223bc45b0968497077eacfe9eeb7e1143ecc782ccd18af454ef215b4c1483"
    sha256 arm64_big_sur:  "47c1c8f8cd49e071be6cda0f729aeaef829ac941e26c87f5ba266d41da423c12"
    sha256 monterey:       "60f51e9c67a707139b2cfa763a961c0778323eae81c1a5aec69c17840ce49e61"
    sha256 big_sur:        "3ee4dfdaea28f1b0c4ebabba8eb677949d1462af4133d4f6b94a60661ab615e7"
    sha256 catalina:       "aca6e4cfc8598dfbd88882622aaeb117f97f1f843c82b87a5308b3fe90740c68"
    sha256 x86_64_linux:   "f61254f8629ce7d463d36db3bd0c5ad36a52ef3ac5989316756eb3703e86a300"
  end

  depends_on "docutils" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.9" => :build
  depends_on xcode: :build

  depends_on "ffmpeg@4"
  depends_on "jpeg"
  depends_on "libarchive"
  depends_on "libass"
  depends_on "little-cms2"
  depends_on "luajit-openresty"
  depends_on "mujs"
  depends_on "uchardet"
  depends_on "vapoursynth"
  depends_on "yt-dlp"

  fails_with gcc: "5" # ffmpeg is compiled with GCC

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
