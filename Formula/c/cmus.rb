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
    rebuild 2
    sha256 arm64_tahoe:   "00ca0987ecc6c79c9b380a96ca9ad3d261567ce97903554ab0367530a39d59bf"
    sha256 arm64_sequoia: "5301455c054375b174fc71cf627383fe7c612d27ac65cdbf9eaf6fd4f3a86343"
    sha256 arm64_sonoma:  "18859fcf9d5693580cb8124027b64a29e6f8820be0d95a9f116e5b87982a7bb5"
    sha256 sonoma:        "e7a5d77b9e0c334f4c5309fb10a163eb80ed8a01dd3f5224c98339cf55bc1bee"
    sha256 arm64_linux:   "2205b91cc172119113461b5a6cbc82d2bcaa557ae484042e9b15acec432b3197"
    sha256 x86_64_linux:  "9af11bfb0fd581b8ccad7ae05a6e1cf30a63b8858167cc25f0859c25917a79e5"
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
