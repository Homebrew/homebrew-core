class Mpv < Formula
  desc "Media player based on MPlayer and mplayer2"
  homepage "https://mpv.io"
  url "https://github.com/mpv-player/mpv/archive/v0.29.1.tar.gz"
  sha256 "f9f9d461d1990f9728660b4ccb0e8cb5dce29ccaa6af567bec481b79291ca623"
  revision 2
  head "https://github.com/mpv-player/mpv.git"

  bottle do
    sha256 "4b15a57a979f20ae92bbd26a16b7f2f466263200c57b0f165651b8d42a083894" => :mojave
    sha256 "79db69bf884b91c481e7b2c987f71674d200354f1e78e62d545c3d886d6700f3" => :high_sierra
    sha256 "697fdbdb8313c795528cc7b161fc1b65c15799cdbbca5b3e972fb52f41374458" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "python" => :build

  depends_on "ffmpeg"
  depends_on "jpeg"
  depends_on "libass"
  depends_on "little-cms2"
  depends_on "lua@5.1"
  depends_on :macos => :mountain_lion
  depends_on "mujs"
  depends_on "vapoursynth"
  depends_on "youtube-dl"

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
      --enable-zsh-comp
      --zshdir=#{zsh_completion}
    ]

    system "./bootstrap.py"
    system "python3", "waf", "configure", *args
    system "python3", "waf", "install"

    system "python3", "TOOLS/osxbundle.py", "build/mpv"
    prefix.install "build/mpv.app"
  end

  test do
    system bin/"mpv", "--ao=null", test_fixtures("test.wav")
  end
end
