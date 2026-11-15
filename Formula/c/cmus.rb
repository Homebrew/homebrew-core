class Cmus < Formula
  desc "Music player with an ncurses based interface"
  homepage "https://cmus.github.io/"
  url "https://github.com/cmus/cmus/archive/refs/tags/v2.13.0.tar.gz"
  sha256 "7be478c476f0a9915cdefbf6aade825a40cd202a8ca6b5149399025d3c7fc09b"
  license "GPL-2.0-or-later"
  head "https://github.com/cmus/cmus.git", branch: "master"

  bottle do
    sha256 arm64_golden_gate: "5cdce6ee3cb238d69a4aba58fc2b82df0f7a095b106572cbf98c354cd36b8f08"
    sha256 arm64_tahoe:       "af3d32f2a8e2cf4c3f6342d4a6fff0dd9afd59eb9f59f66ab275c75468401eec"
    sha256 arm64_sequoia:     "461ef110ead5c0019313800b617d3845d0f62fb025e59e852665f1df43cc22c8"
    sha256 arm64_linux:       "a9f2afd50e9a9eacd8327bf714d2ee2a0650af79c4343db732bb415ffb67f05e"
    sha256 x86_64_linux:      "ee3a1d735bea68bc6d9dd2d5777bd3d67b17607c93ec33871b2b1d9778a6a9e7"
  end

  depends_on "pkgconf" => :build
  depends_on "faad2"
  depends_on "ffmpeg"
  depends_on "flac"
  depends_on "libao" # See https://github.com/cmus/cmus/issues/1130
  depends_on "libvorbis"
  depends_on "mad"
  depends_on "ncurses"
  depends_on "opusfile"

  on_linux do
    depends_on "alsa-lib"
    depends_on "pulseaudio"
  end

  deny_network_access!

  def install
    # https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=765634#10
    # https://www.gnu.org/licenses/license-list.html#MPL
    # https://www.mozilla.org/en-US/MPL/1.1/FAQ/
    odie "mp4v2 is licensed under MPL-1.1 which is incompatible with GPL!" if deps.map(&:name).include?("mp4v2")

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
    expected_plugins += OS.mac? ? %w[coreaudio] : %w[alsa pulse]

    expected_plugins.each do |plugin|
      assert_match plugin, plugins, "#{plugin} plugin not found!"
    end
  end
end
