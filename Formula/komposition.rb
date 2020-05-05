class Komposition < Formula
  desc "Video editor built for screencasters"
  homepage "https://github.com/owickstrom/komposition"
  url "https://github.com/owickstrom/komposition/archive/v0.2.0.tar.gz"
  sha256 "cedb41c68866f8d6a87579f566909fcd32697b03f66c0e2a700a94b6a9263b88"
  revision 1
  head "https://github.com/owickstrom/komposition.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "9f7f1d01243d96dacd400b01ea769d0ca958f0a68c932996c10795b3aa93ebdd" => :catalina
    sha256 "45aaa35a34546a5f53bff691eef76d569a4e3b7ac38f98fa65671f139aebf867" => :mojave
    sha256 "f97514563baca2bc2b744bf0a22d6f346dace4b5ea6caa55ede5142023dc8205" => :high_sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@8.8" => :build
  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
  depends_on "gobject-introspection"
  depends_on "gst-libav"
  depends_on "gst-plugins-base"
  depends_on "gst-plugins-good"
  depends_on "gstreamer"
  depends_on "gstreamer"
  depends_on "gtk+3"
  depends_on "sox"

  uses_from_macos "libffi"

  # fix a constraint issue with protolude
  # remove once new version with
  # https://github.com/owickstrom/komposition/pull/102 is included
  patch do
    url "https://github.com/owickstrom/komposition/pull/102.diff?full_index=1"
    sha256 "bdf561d07f1b8d41a4c030e121becab3b70882da8ccee53c1e91c6c0931fee0c"
  end

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    output = shell_output "#{bin}/komposition doesnotexist 2>&1"
    assert_match "[ERROR] Opening existing project failed: ProjectDirectoryDoesNotExist \"doesnotexist\"", output
  end
end
