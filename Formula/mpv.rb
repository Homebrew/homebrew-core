class Mpv < Formula
  desc "Media player based on MPlayer and mplayer2"
  homepage "https://mpv.io"
  url "https://github.com/mpv-player/mpv/archive/v0.34.1.tar.gz"
  sha256 "32ded8c13b6398310fa27767378193dc1db6d78b006b70dbcbd3123a1445e746"
  license :cannot_represent
  revision 2
  head "https://github.com/mpv-player/mpv.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "6680a239ced8d0dade454815b2380ae3c99d9305d68d77ccc2439ea44a2310f3"
    sha256 arm64_big_sur:  "165cb801353e1c28ecb3a4403a5bafb0a69288f666443b213b2a31bf8f8aada5"
    sha256 monterey:       "003851b807923b134b87607105d3d77d772ef5303bf522dedbfdc5da33a31103"
    sha256 big_sur:        "eeb6652336fcd03fee58987334a54a68c0f6bb3283de1cd1f53b33d3a6976a12"
    sha256 catalina:       "607224a652408e97577b6a126d3b557f0e1f9f033b3cde0cec4c075dc15db931"
    sha256 x86_64_linux:   "6649f91e18bc5af9d3292001296f84de40b996cb4df420e38feb76e0fc83395b"
  end

  depends_on "docutils" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.10" => :build
  depends_on xcode: :build
  depends_on "ffmpeg"
  depends_on "jpeg-turbo"
  depends_on "libarchive"
  depends_on "libass"
  depends_on "little-cms2"
  depends_on "luajit"
  depends_on "mujs"
  depends_on "uchardet"
  depends_on "vapoursynth"
  depends_on "yt-dlp"

  on_linux do
    depends_on "alsa-lib"
  end

  fails_with gcc: "5" # ffmpeg is compiled with GCC

  def install
    # LANG is unset by default on macOS and causes issues when calling getlocale
    # or getdefaultlocale in docutils. Force the default c/posix locale since
    # that's good enough for building the manpage.
    ENV["LC_ALL"] = "C"

    # Avoid unreliable macOS SDK version detection
    # See https://github.com/mpv-player/mpv/pull/8939
    if OS.mac?
      sdk = (MacOS.version == :big_sur) ? MacOS::Xcode.sdk : MacOS.sdk
      ENV["MACOS_SDK"] = sdk.path
      ENV["MACOS_SDK_VERSION"] = "#{sdk.version}.0"
    end

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
      --lua=luajit
    ]

    python3 = "python3.10"
    system python3, "bootstrap.py"
    system python3, "waf", "configure", *args
    system python3, "waf", "install"
  end

  test do
    system bin/"mpv", "--ao=null", "--vo=null", test_fixtures("test.wav")
    assert_match "vapoursynth", shell_output(bin/"mpv --vf=help")
  end
end
