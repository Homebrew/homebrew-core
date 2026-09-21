class Mpv < Formula
  desc "Media player based on MPlayer and mplayer2"
  homepage "https://mpv.io"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]
  revision 9
  compatibility_version 1
  head "https://github.com/mpv-player/mpv.git", branch: "master"

  stable do
    url "https://github.com/mpv-player/mpv/archive/refs/tags/v0.41.0.tar.gz"
    sha256 "ee21092a5ee427353392360929dc64645c54479aefdb5babc5cfbb5fad626209"

    # Backport support for Vapoursynth 74+
    patch do
      url "https://github.com/mpv-player/mpv/commit/75b2ccfeb1ce4ed5a40ac9860fa74f3d1265e13f.patch?full_index=1"
      sha256 "3906b98b02071a0d5747a400406494ca69cef7afd8d3eee4a99fdbe40dc90c1f"
      type :backport
      resolves "https://github.com/mpv-player/mpv/pull/17731"
    end
  end

  bottle do
    sha256 arm64_golden_gate: "3be8690e865b98a3f3f7527acaa72a097b8d7f4d64d38e9242e472cdc98ccad4"
    sha256 arm64_tahoe:       "136d94fc3b285de144445862e16b4a988b032dafb74e126bf5172055182b6457"
    sha256 arm64_sequoia:     "ef4f4e6295d752e686b16750e607ef1955d9df68afce1004744e0462415d1b7a"
    sha256 arm64_sonoma:      "adeccfdd66dd3d5c1a0a6f44dd400b10d01263e876941f8eb03e33975ba6cdc8"
    sha256 arm64_linux:       "a9847b882a10583d069c850a84e96ac241081a9876c1edc972835f2eca8e4ec4"
    sha256 x86_64_linux:      "56173ebbe72abfcbf17681a55eadc3270a45b39937175857f7852deef2769c80"
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
