class Mpv < Formula
  desc "Media player based on MPlayer and mplayer2"
  homepage "https://mpv.io"
  url "https://github.com/mpv-player/mpv/archive/v0.23.0.tar.gz"
  sha256 "8aeefe5970587dfc454d2b89726b603f156bd7a9ae427654eef0d60c68d94998"
  revision 2
  head "https://github.com/mpv-player/mpv.git"

  bottle do
    sha256 "bbdaa890a94248b17b7c2392a55b6622b92a6a227ff399c2420c2220fe4782d6" => :sierra
    sha256 "fe79cd4ee36482396dbe2f277b2d9a8d0ea59ad6e2b9a0a6f2738c7ddf693251" => :el_capitan
    sha256 "1d1f7a7b579d81af738477523d6c5240380bc8352ac75a5b354d0d9328dcbc0c" => :yosemite
  end

  option "with-bundle", "Enable compilation of the .app bundle."

  depends_on "pkg-config" => :build
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

  resource "docutils" do
    url "https://files.pythonhosted.org/packages/05/25/7b5484aca5d46915493f1fd4ecb63c38c333bd32aa9ad6e19da8d08895ae/docutils-0.13.1.tar.gz"
    sha256 "718c0f5fb677be0f34b781e04241c4067cbd9327b66bdd8e763201130f5175be"
  end

  def install
    # LANG is unset by default on osx and causes issues when calling getlocale
    # or getdefaultlocale in docutils. Force the default c/posix locale since
    # that's good enough for building the manpage.
    ENV["LC_ALL"] = "C"

    ENV.prepend_create_path "PYTHONPATH", buildpath/"vendor/lib/python2.7/site-packages"
    resource("docutils").stage do
      system "python", *Language::Python.setup_install_args(buildpath/"vendor")
    end
    ENV.prepend_path "PATH", buildpath/"vendor/bin"

    args = %W[
      --prefix=#{prefix}
      --enable-zsh-comp
      --enable-libmpv-shared
      --enable-html-build
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
