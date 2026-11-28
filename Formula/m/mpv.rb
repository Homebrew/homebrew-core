class Mpv < Formula
  desc "Media player based on MPlayer and mplayer2"
  homepage "https://mpv.io"
  url "https://github.com/mpv-player/mpv/archive/refs/tags/v0.42.0.tar.gz"
  sha256 "bcfebbfa2b65a6d88dc97ea18117831072373e38b5785a2afb874ed4df5070dd"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]
  revision 1
  compatibility_version 1
  head "https://github.com/mpv-player/mpv.git", branch: "master"

  bottle do
    manifest_sha256 "6cc78a1ba72ff4eb5263f44063d9c8cac04e45260da73d91922cbfda4efcbe48"
    sha256 arm64_golden_gate: "20f3540339b3d73a174c3661d9388e2c7bc9f972acbfc3b6e771f7042b47745d"
    sha256 arm64_tahoe:       "6a1b54f165edafb7b4a7b3d09b5e88097d6fcfb1dd91f94a1bea9dc1803f2d2d"
    sha256 arm64_sequoia:     "05850494459b51fee48c8b5c394257b616318cf226d58a108a2eb0232b233601"
    sha256 arm64_linux:       "925ff4382a3289fc919924ffa8796dba503d48b99c4026a40ab40c3c039c5f7a"
    sha256 x86_64_linux:      "6ce1761d1f9a30bf856bfa370f79ecf0c4ef009d72c54fb369557c8b8257461d"
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
  end
end
