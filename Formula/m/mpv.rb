class Mpv < Formula
  desc "Media player based on MPlayer and mplayer2"
  homepage "https://mpv.io"
  license :cannot_represent
  revision 3
  head "https://github.com/mpv-player/mpv.git", branch: "master"

  stable do
    url "https://github.com/mpv-player/mpv/archive/refs/tags/v0.37.0.tar.gz"
    sha256 "1d2d4adbaf048a2fa6ee134575032c4b2dad9a7efafd5b3e69b88db935afaddf"

    # Fix build with FFmpeg 7.0.
    # Remove when included in a release.
    # https://github.com/mpv-player/mpv/pull/13659
    patch do
      url "https://github.com/mpv-player/mpv/commit/62b1bad755bb6141c5a704741bda8a4da6dfcde5.patch?full_index=1"
      sha256 "7d6119161f8d2adcc62c8841cee7ea858bf46e51e8d828248ca2133281e2df0a"
    end
    patch do
      url "https://github.com/mpv-player/mpv/commit/78447c4b91634aa91dcace1cc6a9805fb93b9252.patch?full_index=1"
      sha256 "69e4ead829e36b3a175e40ed3c58cc4291a5b6634da70d02b0a5191b9e6d03f6"
    end

    # Fix MKV audio playing.
    # Remove when included in a release.
    # https://github.com/mpv-player/mpv/pull/13665
    patch do
      url "https://github.com/mpv-player/mpv/commit/1a40b2f9281dba1d7e75ce03fec1fe4bb2902a17.patch?full_index=1"
      sha256 "0f06294d7a2c0fecae88937887a3aa98c706398ba35a0a27b2908612585db98f"
    end
    patch do
      url "https://github.com/mpv-player/mpv/commit/b5599872c768ed0df79d6b50755e4568fb06e3ab.patch?full_index=1"
      sha256 "7c82044c44ec0851f3a82527e1699b7636099ebddaa0ab3732f62aa1fbce5beb"
    end
  end

  bottle do
    sha256 arm64_sonoma:   "0285f66c079b42365e67e60f52a861d129e0f2f04f02fc1d1fcc2632e143ded4"
    sha256 arm64_ventura:  "ffd7bea5632b2a5e7a1081cf16436d1b9c01f8e56a0bc24531d715049e230eeb"
    sha256 arm64_monterey: "fb1a5c00231edf01026c878fad9ce288a480f4eec32a23f2c0a8ec29cba695d7"
    sha256 sonoma:         "c5fdb82788fe1b286540d7cabdfc806dfd6f88a05d9d6232a9be315aa8463633"
    sha256 ventura:        "d479b319c26fd8490079480c7c6f9204f38a764561583cd17af833539697cf91"
    sha256 monterey:       "de3b0e62b11154e1b4ce58d9d0f8b60d9d75ab58cdaa485d76d7cfe4d1cb3108"
    sha256 x86_64_linux:   "f098d552c279a75f35b980e8ebc7ce172617b03805249caa5e2466c6ac3bdd2c"
  end

  depends_on "docutils" => :build
  depends_on "meson" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on xcode: :build
  depends_on "ffmpeg"
  depends_on "jpeg-turbo"
  depends_on "libarchive"
  depends_on "libass"
  depends_on "libplacebo"
  depends_on "little-cms2"
  depends_on "luajit"
  depends_on "mujs"
  depends_on "uchardet"
  depends_on "vapoursynth"
  depends_on "yt-dlp"

  on_linux do
    depends_on "alsa-lib"
  end

  def install
    # LANG is unset by default on macOS and causes issues when calling getlocale
    # or getdefaultlocale in docutils. Force the default c/posix locale since
    # that's good enough for building the manpage.
    ENV["LC_ALL"] = "C"

    # force meson find ninja from homebrew
    ENV["NINJA"] = Formula["ninja"].opt_bin/"ninja"

    # libarchive is keg-only
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["libarchive"].opt_lib/"pkgconfig"

    args = %W[
      -Dhtml-build=enabled
      -Djavascript=enabled
      -Dlibmpv=true
      -Dlua=luajit
      -Dlibarchive=enabled
      -Duchardet=enabled
      --sysconfdir=#{pkgetc}
      --datadir=#{pkgshare}
      --mandir=#{man}
    ]

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"

    if OS.mac?
      # `pkg-config --libs mpv` includes libarchive, but that package is
      # keg-only so it needs to look for the pkgconfig file in libarchive's opt
      # path.
      libarchive = Formula["libarchive"].opt_prefix
      inreplace lib/"pkgconfig/mpv.pc" do |s|
        s.gsub!(/^Requires\.private:(.*)\blibarchive\b(.*?)(,.*)?$/,
                "Requires.private:\\1#{libarchive}/lib/pkgconfig/libarchive.pc\\3")
      end
    end

    bash_completion.install "etc/mpv.bash-completion" => "mpv"
    zsh_completion.install "etc/_mpv.zsh" => "_mpv"
  end

  test do
    system bin/"mpv", "--ao=null", "--vo=null", test_fixtures("test.wav")
    assert_match "vapoursynth", shell_output(bin/"mpv --vf=help")

    # Make sure `pkg-config` can parse `mpv.pc` after the `inreplace`.
    system "pkg-config", "mpv"
  end
end
