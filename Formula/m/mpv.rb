class Mpv < Formula
  desc "Media player based on MPlayer and mplayer2"
  homepage "https://mpv.io"
  url "https://github.com/mpv-player/mpv/archive/refs/tags/v0.42.0.tar.gz"
  sha256 "bcfebbfa2b65a6d88dc97ea18117831072373e38b5785a2afb874ed4df5070dd"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]
  compatibility_version 1
  head "https://github.com/mpv-player/mpv.git", branch: "master"

  bottle do
    sha256 arm64_golden_gate: "0d9ff71b2875fd4e816285816338399f6532f86e721c50fd369fb588f01fcce6"
    sha256 arm64_tahoe:       "f5d6799317ea1d88a5339e318c335938b37615d1e1ae2cc1a048d7705bb2f79f"
    sha256 arm64_sequoia:     "8b25fdd54ea368d97283e17f0ceab4ce713d670ebd8d410e5064da8dd6e9d891"
    sha256 arm64_linux:       "054c749069bf73de193dc274d5bc6a89592ec0083debacea155d1d370d92b40e"
    sha256 x86_64_linux:      "5b160ea629e2a143338c5292d2ba7ccaa5a5f70e820b918ccf9f1f54cd3661a3"
  end

  depends_on "docutils" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
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

  on_macos do
    depends_on "molten-vk"
  end

  on_linux do
    depends_on "alsa-lib"
    depends_on "libva"
    depends_on "libvdpau"
    depends_on "libx11"
    depends_on "libxext"
    depends_on "libxfixes"
    depends_on "libxkbcommon"
    depends_on "libxpresent"
    depends_on "libxrandr"
    depends_on "libxscrnsaver"
    depends_on "libxv"
    depends_on "mesa"
    depends_on "pipewire"
    depends_on "pulseaudio"
    depends_on "wayland"
    depends_on "wayland-protocols" => :no_linkage # needed by mpv.pc
    depends_on "zlib-ng-compat"
  end

  def install
    args = %W[
      --sysconfdir=#{etc}
      -Dbuild-date=false
      -Dhtml-build=enabled
      -Djavascript=enabled
      -Dlibmpv=true
      -Dlua=luajit
      -Dlibarchive=enabled
      -Duchardet=enabled
      -Dvulkan=enabled
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
    bash_completion.install share/"bash-completion/completions/mpv"

    return unless OS.mac?

    # `pkg-config --libs mpv` includes libarchive, but that package is
    # keg-only so it needs to look for the pkgconfig file in libarchive's opt
    # path.
    libarchive = formula_opt_prefix("libarchive")
    inreplace lib/"pkgconfig/mpv.pc",
              /^Requires\.private:(.*)\blibarchive\b(.*?)(,.*)?$/,
              "Requires.private:\\1#{libarchive}/lib/pkgconfig/libarchive.pc\\3"
  end

  def caveats
    <<~EOS
      The global configuration directory is now #{pkgetc}/
      You may need to migrate any data in previous #{pkgetc}/mpv/
    EOS
  end

  test do
    system bin/"mpv", "--ao=null", "--vo=null", test_fixtures("test.wav")
    assert_match "vapoursynth", shell_output("#{bin}/mpv --vf=help")

    # Make sure `pkgconf` can parse `mpv.pc` after the `inreplace`.
    system "pkgconf", "--print-errors", "mpv"
  end
end
