class Cmus < Formula
  desc "Music player with an ncurses based interface"
  homepage "https://cmus.github.io/"
  license "GPL-2.0-or-later"
  revision 4
  head "https://github.com/cmus/cmus.git", branch: "master"

  stable do
    url "https://github.com/cmus/cmus/archive/refs/tags/v2.12.0.tar.gz"
    sha256 "44b96cd5f84b0d84c33097c48454232d5e6a19cd33b9b6503ba9c13b6686bfc7"

    # Backport FFmpeg 8 support using Debian patches as recommended by upstream
    # The same patches are used by Arch Linux.
    patch do
      url "https://deb.debian.org/debian/pool/main/c/cmus/cmus_2.12.0-3.debian.tar.xz"
      sha256 "dcdbda04f42785079be734c3282e8a114a1ee55da01505ac92da56778bd035a4"
      type :backport
      resolves "https://github.com/cmus/cmus/issues/1459"
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
    sha256 arm64_tahoe:   "210377c9fda621f2405c82368826b836f477a2b6c810074ade5827d838bf3dd3"
    sha256 arm64_sequoia: "cfe58b83c5dcd733e8d0b30920ab783cb68518e6369fd7fa66f2a15f806fa72e"
    sha256 arm64_sonoma:  "f051ca658766a48c546040fc6fed6d76f2a5014174e2ac8dddd34b23cfa36a88"
    sha256 sonoma:        "e557635620a6cb4182d3ad7dd754b41ccfd41060183346e808236c2a4438626c"
    sha256 arm64_linux:   "27ad28ba4977fe3cba76ba21fca347507b66fd97e297761224da4bcb2cc73d9b"
    sha256 x86_64_linux:  "74ac30d857315bdd36ca022035ba04b2326486ead7c9ab44853536a48e807670"
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
