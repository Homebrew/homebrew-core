class Mpv < Formula
  desc "Media player based on MPlayer and mplayer2"
  homepage "https://mpv.io"
  url "https://github.com/mpv-player/mpv/archive/v0.29.0.tar.gz"
  sha256 "772af878cee5495dcd342788a6d120b90c5b1e677e225c7198f1e76506427319"
  head "https://github.com/mpv-player/mpv.git"

  bottle do
    sha256 "1dee05ae50b43c059c11c667a2e70b51bccfb373248ad8f877eeef9a8afe7c67" => :high_sierra
    sha256 "9c43d85b504b5edd2cbcf87ed219dc7a75c771b763e66fd64305b93c5070c993" => :sierra
    sha256 "301203ddeb374ecce692a47b59ff8396b63e2f40530f6f82dc037992a53a0ebc" => :el_capitan
  end

  option "with-bundle", "Enable compilation of the .app bundle."
  option "with-lgpl", "Build with LGPLv2.1 or later license"

  depends_on "pkg-config" => :build
  depends_on "python" => :build

  depends_on "libass"
  depends_on "ffmpeg"
  depends_on "lua@5.1"

  depends_on "jpeg" => :recommended
  depends_on "little-cms2" => :recommended
  depends_on "mujs" => :recommended
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

  resource "docutils" do
    url "https://files.pythonhosted.org/packages/84/f4/5771e41fdf52aabebbadecc9381d11dea0fa34e4759b4071244fa094804c/docutils-0.14.tar.gz"
    sha256 "51e64ef2ebfb29cae1faa133b3710143496eca21c530f3f71424d77687764274"
  end

  patch do
    url "https://github.com/mpv-player/mpv/pull/6004.patch?full_index=1"
    sha256 "65bfeac2e02847d72d54ac55e9da0011556fd4a6466151927e0535d2355a8ffd"
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
      --enable-libmpv-shared
      --enable-html-build
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
    args << "--enable-javascript" if build.with? "mujs"
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
