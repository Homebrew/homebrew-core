class Komposition < Formula
  desc "Video editor built for screencasters"
  homepage "https://github.com/owickstrom/komposition"
  url "https://github.com/owickstrom/komposition/archive/v0.2.0.tar.gz"
  sha256 "cedb41c68866f8d6a87579f566909fcd32697b03f66c0e2a700a94b6a9263b88"
  license "MPL-2.0"
  revision 3
  head "https://github.com/owickstrom/komposition.git"

  bottle do
    cellar :any
    sha256 "dc76316ff64beb2d4756ba554844a57d546a0bbe8a300ce1879a6cddcb72ebf8" => :catalina
    sha256 "e78904afced48a6365ec5cec4b9e97ecccf4bf81401c5576a0c3b21fa1078264" => :mojave
    sha256 "137747b62de4e68164bceccd009beb65606ae6ba2c94fbe9a72b0eee50ae0961" => :high_sierra
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
    url "https://github.com/owickstrom/komposition/commit/e6c575cf8eddc3be30471df9a9dd92b3cb9f70c1.diff?full_index=1"
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
