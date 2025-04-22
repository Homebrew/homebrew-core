class Mpv < Formula
  desc "Media player based on MPlayer and mplayer2"
  homepage "https://mpv.io"
  url "https://github.com/mpv-player/mpv/archive/refs/tags/v0.40.0.tar.gz"
  sha256 "10a0f4654f62140a6dd4d380dcf0bbdbdcf6e697556863dc499c296182f081a3"
  license :cannot_represent
  head "https://github.com/mpv-player/mpv.git", branch: "master"

  bottle do
    sha256 arm64_sequoia: "5955cf22cdde31fa7f6968d63af6bc9349b46cc8b0b8c16106a0b6472f4a37ef"
    sha256 arm64_sonoma:  "6f109ef9959b7a8cf389253c951d522da82102156679fe3b2c83d96d21bbe982"
    sha256 arm64_ventura: "0cd6d5afa3c9fdf52939b3efe53542669d4dc3eb36bad2fd81fee909cc7894c5"
    sha256 sonoma:        "fbf379a4b04f73397466692ff0977972862178e93702cdb106ee5f0897f89fb9"
    sha256 ventura:       "edbd8605a162f20ddcfad0cff8d0f3626c394eef645d89d0329017a2770a101d"
    sha256 arm64_linux:   "2f2da23614a1d6b915b5016f68e485819a3e7d8bd94a5ef496adcdddd5c9ab87"
    sha256 x86_64_linux:  "3f8d46888b8a730bbb89dc414f032f3137d8f9cdd6cb410270a31a1bae04674a"
  end

  depends_on "docutils" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on xcode: :build
  depends_on "ffmpeg"
  depends_on "jpeg-turbo"
  depends_on "libarchive"
  depends_on "libass"
  depends_on "libbluray"
  depends_on "libplacebo"
  depends_on "little-cms2"
  depends_on "luajit"
  depends_on "mujs"
  depends_on "rubberband"
  depends_on "uchardet"
  depends_on "vapoursynth"
  depends_on "vulkan-loader"
  depends_on "yt-dlp"
  depends_on "zimg"

  uses_from_macos "zlib"

  on_macos do
    depends_on "molten-vk"
  end

  on_ventura :or_older do
    depends_on "lld" => :build
  end

  on_linux do
    depends_on "alsa-lib"
    depends_on "libdrm"
    depends_on "libva"
    depends_on "libvdpau"
    depends_on "libx11"
    depends_on "libxext"
    depends_on "libxkbcommon"
    depends_on "libxpresent"
    depends_on "libxrandr"
    depends_on "libxscrnsaver"
    depends_on "libxv"
    depends_on "mesa"
    depends_on "pulseaudio"
    depends_on "wayland"
    depends_on "wayland-protocols" # needed by mpv.pc
  end

  conflicts_with cask: "stolendata-mpv", because: "both install `mpv` binaries"

  def install
    # LANG is unset by default on macOS and causes issues when calling getlocale
    # or getdefaultlocale in docutils. Force the default c/posix locale since
    # that's good enough for building the manpage.
    ENV["LC_ALL"] = "C"

    # force meson find ninja from homebrew
    ENV["NINJA"] = which("ninja")

    # libarchive is keg-only
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["libarchive"].opt_lib/"pkgconfig" if OS.mac?

    # Work around https://github.com/mpv-player/mpv/issues/15591
    # This bug happens running classic ld, which is the default
    # prior to Xcode 15 and we enable it in the superenv prior to
    # Xcode 15.3 when using -dead_strip_dylibs (default for meson).
    if OS.mac? && MacOS.version <= :ventura
      ENV.append "LDFLAGS", "-fuse-ld=lld"
      ENV.O1 # -Os is not supported for lld and we don't have ENV.O2
    end

    args = %W[
      -Dbuild-date=false
      -Dhtml-build=enabled
      -Djavascript=enabled
      -Dlibmpv=true
      -Dlua=luajit
      -Dlibarchive=enabled
      -Duchardet=enabled
      -Dvulkan=enabled
      --sysconfdir=#{pkgetc}
      --datadir=#{pkgshare}
      --mandir=#{man}
    ]
    if OS.linux?
      args += %w[
        -Degl=enabled
        -Dwayland=enabled
        -Dx11=enabled
      ]
    end

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

    # Make sure `pkgconf` can parse `mpv.pc` after the `inreplace`.
    system "pkgconf", "--print-errors", "mpv"
  end
end
