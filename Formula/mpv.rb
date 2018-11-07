class Mpv < Formula
  desc "Media player based on MPlayer and mplayer2"
  homepage "https://mpv.io"
  url "https://github.com/mpv-player/mpv/archive/v0.29.1.tar.gz"
  sha256 "f9f9d461d1990f9728660b4ccb0e8cb5dce29ccaa6af567bec481b79291ca623"
  revision 1
  head "https://github.com/mpv-player/mpv.git"

  bottle do
    sha256 "37957b0d09f6d214501afedf86e4819cc4ef6ae2e14eeca4cc72590c8838cf77" => :mojave
    sha256 "581bfc39b0c3d8e91f2f5d2529d4b27d6db854ded5daf3b7fa3f71260034ba1d" => :high_sierra
    sha256 "01dd3eb9eef24754c2279b16607bfed281a481c6a0e6af357b63b78a8bf50053" => :sierra
  end

  option "with-bundle", "Enable compilation of the .app bundle."
  option "with-lgpl", "Build with LGPLv2.1 or later license"

  depends_on "pkg-config" => :build
  depends_on "python" => :build

  depends_on "ffmpeg"
  depends_on "jpeg"
  depends_on "libass"
  depends_on "little-cms2"
  depends_on "lua@5.1"
  depends_on :macos => :mountain_lion
  depends_on "mujs"
  depends_on "youtube-dl"

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

  resource "docutils" do
    url "https://files.pythonhosted.org/packages/84/f4/5771e41fdf52aabebbadecc9381d11dea0fa34e4759b4071244fa094804c/docutils-0.14.tar.gz"
    sha256 "51e64ef2ebfb29cae1faa133b3710143496eca21c530f3f71424d77687764274"
  end

  def install
    # LANG is unset by default on macOS and causes issues when calling getlocale
    # or getdefaultlocale in docutils. Force the default c/posix locale since
    # that's good enough for building the manpage.
    ENV["LC_ALL"] = "C"

    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", buildpath/"vendor/lib/python#{xy}/site-packages"
    resource("docutils").stage do
      system "python3", *Language::Python.setup_install_args(buildpath/"vendor")
    end
    ENV.prepend_path "PATH", buildpath/"vendor/bin"

    args = %W[
      --prefix=#{prefix}
      --enable-html-build
      --enable-javascript
      --enable-libmpv-shared
      --enable-lua
      --confdir=#{etc}/mpv
      --datadir=#{pkgshare}
      --mandir=#{man}
      --docdir=#{doc}
    ]
    args << "--enable-libarchive" if build.with? "libarchive"
    args << "--enable-libbluray" if build.with? "libbluray"
    args << "--enable-dvdnav" if build.with? "libdvdnav"
    args << "--enable-dvdread" if build.with? "libdvdread"
    args << "--enable-pulse" if build.with? "pulseaudio"

    if build.with? "lgpl"
      args << "--enable-lgpl"
    else
      args << "--enable-zsh-comp"
      args << "--zshdir=#{zsh_completion}"
    end

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
