class Cmus < Formula
  desc "Music player with an ncurses based interface"
  homepage "https://cmus.github.io/"
  license "GPL-2.0-or-later"
  revision 3
  head "https://github.com/cmus/cmus.git", branch: "master"

  stable do
    url "https://github.com/cmus/cmus/archive/refs/tags/v2.12.0.tar.gz"
    sha256 "44b96cd5f84b0d84c33097c48454232d5e6a19cd33b9b6503ba9c13b6686bfc7"

    # Backport FFmpeg 8 support using Debian patches as recommended by upstream
    # https://github.com/cmus/cmus/issues/1459#issuecomment-3733435414
    # The same patches are used by Arch Linux.
    patch do
      url "https://deb.debian.org/debian/pool/main/c/cmus/cmus_2.12.0-2.debian.tar.xz"
      sha256 "e7b29301e3edd7446fa7bc4c4e89ea5a4580a13e183cc57a59974ca385ec9818"
      apply "patches/0003-ip-ffmpeg-more-precise-seeking.patch",
            "patches/0004-ip-ffmpeg-skip-samples-only-when-needed.patch",
            "patches/0005-ip-ffmpeg-remove-excessive-version-checks.patch",
            "patches/0006-ip-ffmpeg-major-refactor.patch",
            "patches/0007-Validate-sample-format-in-ip_open.patch",
            "patches/0008-ip-ffmpeg-flush-swresample-buffer-when-seeking.patch",
            "patches/0009-ip-ffmpeg-remember-swr_frame-s-capacity.patch",
            "patches/0010-ip-ffmpeg-reset-swr_frame_start-when-seeking.patch",
            "patches/0011-ip-ffmpeg-better-frame-skipping-logic.patch",
            "patches/0012-ip-ffmpeg-don-t-process-empty-frames.patch",
            "patches/0013-ip-ffmpeg-improve-readability.patch",
            "patches/0014-ip-ffmpeg-fix-building-for-ffmpeg-8.0.patch",
            "patches/0015-ip-ffmpeg-change-sample-format-conversions.patch"
    end
  end

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "51b42ebc31527eea5562974b745eb1c961436282882ffed5a183e043a997987d"
    sha256 arm64_sequoia: "9878efe2232228b9e5e67a588ebd22867bb0b13fb9d7155bb1c697d2ecaf0376"
    sha256 arm64_sonoma:  "c13b26723f0d2547bb8fcc31d8437c738c437f01f4245b281e294e0c3928d7f7"
    sha256 sonoma:        "09934b3459b7b8d617aa3f46f6a7012d245d92d85d70a3c46fd22f80d8dff083"
    sha256 arm64_linux:   "5ac1322da5e1d6ab4dd872e5a50dfc938628f9d6e57d2454c8e6435c4eb004cf"
    sha256 x86_64_linux:  "47bdd3c67a317fd239b8af7b6e0a177e16ba1047c729e30af4dfb4b6598ed878"
  end

  depends_on "pkgconf" => :build
  depends_on "faad2"
  depends_on "ffmpeg"
  depends_on "flac"
  depends_on "libao" # See https://github.com/cmus/cmus/issues/1130
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
