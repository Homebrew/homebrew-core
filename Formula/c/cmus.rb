class Cmus < Formula
  desc "Music player with an ncurses based interface"
  homepage "https://cmus.github.io/"
  url "https://github.com/cmus/cmus/archive/refs/tags/v2.12.0.tar.gz"
  sha256 "44b96cd5f84b0d84c33097c48454232d5e6a19cd33b9b6503ba9c13b6686bfc7"
  license "GPL-2.0-or-later"
  revision 3
  head "https://github.com/cmus/cmus.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "ccb3ef033e545c2f1610612c73c28ee5b2d195829f8a061137ff6345ba7198ec"
    sha256 arm64_sequoia: "e09385ddb5a370d854f4608b76c5a263541547ac91b7cc4a6517e1f3099a19a3"
    sha256 arm64_sonoma:  "a9d12ff2708a54953541bc5ae8ccb1ef3fd24aeb3365dbc8834337076faebd72"
    sha256 arm64_ventura: "ae3c328349aeb668ccb369a9aa2a6147e6718aec702cffc145de37a0f3b82e0e"
    sha256 sonoma:        "f67433b09c4f9f4c52ac189f99277c1698d8869196bf992265784b18ab63c443"
    sha256 ventura:       "af29c51757aea6aaf9c7aab6758ec590e31f7f5e323a7c682f76496fb8e1599e"
    sha256 arm64_linux:   "6d9800c3e1c74383aa02badeb42de89294de79afacb0fdeb7e09770e40ef9b4b"
    sha256 x86_64_linux:  "6fa906d04b003647aec2093fa275eee0d2ca65d1601b6048b76dfa2016e0ba4e"
  end

  depends_on "pkgconf" => :build
  depends_on "faad2"
  depends_on "ffmpeg@7" # FFmpeg 8 issue: https://github.com/cmus/cmus/issues/1446
  depends_on "flac"
  depends_on "libao" # See https://github.com/cmus/cmus/issues/1130
  depends_on "libcue"
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "mad"
  depends_on "mp4v2"
  depends_on "ncurses"
  depends_on "opusfile"

  on_linux do
    depends_on "alsa-lib"
    depends_on "pulseaudio"
  end

  def install
    args = [
      "prefix=#{prefix}",
      "mandir=#{man}",
      "CONFIG_WAVPACK=n",
      "CONFIG_MPC=n",
      "CONFIG_AO=y",
    ]
    system "./configure", *args
    system "make", "install"
  end

  test do
    plugins = shell_output("#{bin}/cmus --plugins")
    expected_plugins = %w[
      aac
      cue
      ffmpeg
      flac
      mad
      mp4
      opus
      vorbis
      wav
      ao
    ]
    expected_plugins += if OS.mac?
      %w[coreaudio]
    else
      %w[alsa pulse]
    end

    expected_plugins.each do |plugin|
      assert_match plugin, plugins, "#{plugin} plugin not found!"
    end
  end
end
