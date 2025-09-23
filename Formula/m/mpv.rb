class Mpv < Formula
  desc "Media player based on MPlayer and mplayer2"
  homepage "https://mpv.io"
  license :cannot_represent
  revision 4
  head "https://github.com/mpv-player/mpv.git", branch: "master"

  stable do
    url "https://github.com/mpv-player/mpv/archive/refs/tags/v0.40.0.tar.gz"
    sha256 "10a0f4654f62140a6dd4d380dcf0bbdbdcf6e697556863dc499c296182f081a3"

    # Backport support for FFmpeg 8
    patch do
      url "https://github.com/mpv-player/mpv/commit/26b29fba02a2782f68e2906f837d21201fc6f1b9.patch?full_index=1"
      sha256 "ac7e5d8e765186af2da3bef215ec364bd387d43846ee776bd05f01f9b9e679b2"
    end
  end

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "106cc0184a6703e9c3e9a4b3662b3a65da4e64c8a2e43218d1fc19493cdecdb8"
    sha256 arm64_sequoia: "2a72093cc0689a0c6341b7abc942ba0ec802490c807ff764ac20edb6f0ead270"
    sha256 arm64_sonoma:  "8247120427ca93debacb0b079ba30dd9d233e8f8f0705e9a82899a4fee833157"
    sha256 arm64_ventura: "20afc0a4fe70131481e5a8fcd91a803806965bb76e106a326eae6ee5864bce2f"
    sha256 sonoma:        "eb40fe0c534999a9771f3666824c0d70488afd06f96c37a1d26821f5537e5fb9"
    sha256 ventura:       "af91158356583eb46de5fb7dbc999eeee2d2606336fb4276eb5713daf9efa580"
    sha256 arm64_linux:   "16e483fc11b83570cd434a3f9b44b69afccf90f5091adca702a6200b269a80fb"
    sha256 x86_64_linux:  "ae8b059abf68381c7f62d9190dca745f36971ad1b0a1080c6d69a05bd3ac5b42"
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
    assert_match "vapoursynth", shell_output("#{bin}/mpv --vf=help")

    # Make sure `pkgconf` can parse `mpv.pc` after the `inreplace`.
    system "pkgconf", "--print-errors", "mpv"
  end
end
