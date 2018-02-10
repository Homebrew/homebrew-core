class Mpv < Formula
  desc "Media player based on MPlayer and mplayer2"
  homepage "https://mpv.io"
  revision 6

  head "https://github.com/mpv-player/mpv.git"

  stable do
    url "https://github.com/mpv-player/mpv/archive/v0.27.0.tar.gz"
    sha256 "341d8bf18b75c1f78d5b681480b5b7f5c8b87d97a0d4f53a5648ede9c219a49c"

    # Fix CVE-2018-6360, because arbitrary code execution isn't ideal.
    patch do
      url "https://mirrors.ocf.berkeley.edu/debian/pool/main/m/mpv/mpv_0.27.0-4.debian.tar.xz"
      mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/m/mpv/mpv_0.27.0-4.debian.tar.xz"
      sha256 "1005421e8a384e42bf4f490ede95ba444b7f0d9958a043fe1878a4d9fb9168be"
      apply "patches/09_ytdl-hook-whitelist-protocols.patch"
    end
  end

  bottle do
    sha256 "400407134ecae015f75a45c27ab0bec2087310737f7fd14f3849a21834c415a7" => :high_sierra
    sha256 "82dc721763626f8acf23e374b28c1a7fe7ade4675286dd34cdd5eebe616da2d1" => :sierra
    sha256 "67d08c667592b5c6138d3a0e80cc2e3887bea46ddee0f3f5a8411cf08db1f839" => :el_capitan
  end

  option "with-bundle", "Enable compilation of the .app bundle."

  depends_on "pkg-config" => :build
  depends_on "python3" => :build

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
    url "https://files.pythonhosted.org/packages/05/25/7b5484aca5d46915493f1fd4ecb63c38c333bd32aa9ad6e19da8d08895ae/docutils-0.13.1.tar.gz"
    sha256 "718c0f5fb677be0f34b781e04241c4067cbd9327b66bdd8e763201130f5175be"
  end

  def install
    # LANG is unset by default on macOS and causes issues when calling getlocale
    # or getdefaultlocale in docutils. Force the default c/posix locale since
    # that's good enough for building the manpage.
    ENV["LC_ALL"] = "C"

    # Prevents a conflict between python2 and python3 when gobject-introspection
    # is using the :python requirement
    ENV.delete("PYTHONPATH") if MacOS.version <= :mavericks

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
      --enable-lua
      --confdir=#{etc}/mpv
      --datadir=#{pkgshare}
      --mandir=#{man}
      --docdir=#{doc}
      --zshdir=#{zsh_completion}
    ]
    args << "--enable-libarchive" if build.with? "libarchive"
    args << "--enable-libbluray" if build.with? "libbluray"
    args << "--enable-dvdnav" if build.with? "libdvdnav"
    args << "--enable-dvdread" if build.with? "libdvdread"
    args << "--enable-javascript" if build.with? "mujs"
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
