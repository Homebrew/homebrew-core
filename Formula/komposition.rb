class Komposition < Formula
  desc "Video editor built for screencasters"
  homepage "https://github.com/owickstrom/komposition"
  url "https://github.com/owickstrom/komposition/archive/v0.2.0.tar.gz"
  sha256 "cedb41c68866f8d6a87579f566909fcd32697b03f66c0e2a700a94b6a9263b88"
  head "https://github.com/owickstrom/komposition.git"

  bottle do
    sha256 "f28f804f8ca5d9c9c23f8fd9d35edb3276e2d397abbbf73fda33b543d5654611" => :catalina
    sha256 "2f7008e5a901c7c4739104124c0a3faea211f3d7509c0c19f6a28f8de162be08" => :mojave
    sha256 "75c13e6a1a9f53273974f6445d4d59adc76c16399480f305547e7bddd5237fbd" => :high_sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
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

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    output = shell_output "#{bin}/komposition doesnotexist 2>&1"
    assert_match "[ERROR] Opening existing project failed: ProjectDirectoryDoesNotExist \"doesnotexist\"", output
  end
end
