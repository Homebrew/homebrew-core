class Mpv < Formula
  desc "Media player based on MPlayer and mplayer2"
  homepage "https://mpv.io"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]
  revision 6
  compatibility_version 1
  head "https://github.com/mpv-player/mpv.git", branch: "master"

  stable do
    url "https://github.com/mpv-player/mpv/archive/refs/tags/v0.41.0.tar.gz"
    sha256 "ee21092a5ee427353392360929dc64645c54479aefdb5babc5cfbb5fad626209"

    # Backport support for Vapoursynth 74+
    patch do
      url "https://github.com/mpv-player/mpv/commit/75b2ccfeb1ce4ed5a40ac9860fa74f3d1265e13f.patch?full_index=1"
      sha256 "3906b98b02071a0d5747a400406494ca69cef7afd8d3eee4a99fdbe40dc90c1f"
    end
  end

  bottle do
    rebuild 1
    sha256               arm64_tahoe:   "0056b72213336a232c8d8a0f70dea46b43baac856f898ff891754660a3bbb5c1"
    sha256               arm64_sequoia: "d594fd4964183fcf6313fccf3a2dac5ac3e28ab59848fe6ffbc446ce9ab20b1d"
    sha256               arm64_sonoma:  "274495c2986f894e27b1fec9652b07b4326ef77a764217b02b99da7a15f0066f"
    sha256 cellar: :any, sonoma:        "73f9cd88e549e1ceedb1f162c5ff0e62b827691b2f3b15d2ebbdb8ef64f6dd78"
    sha256               arm64_linux:   "af0fcc75360279e3aa657ed51a7739f77f4461c26c88b7212a826a3efbf3e169"
    sha256               x86_64_linux:  "a8a46da28614723b7fd14ce87bbce65092b5bda0821b82d0d702b70cbc30219f"
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

  conflicts_with cask: "stolendata-mpv", because: "both install `mpv` binaries"

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
