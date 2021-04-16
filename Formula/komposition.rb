class Komposition < Formula
  desc "Video editor built for screencasters"
  homepage "https://github.com/owickstrom/komposition"
  url "https://github.com/owickstrom/komposition/archive/v0.2.0.tar.gz"
  sha256 "cedb41c68866f8d6a87579f566909fcd32697b03f66c0e2a700a94b6a9263b88"
  license "MPL-2.0"
  revision 5
  head "https://github.com/owickstrom/komposition.git"

  disable! date: "2021-04-08", because: :does_not_build

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
    url "https://github.com/owickstrom/komposition/commit/e6c575cf8eddc3be30471df9a9dd92b3cb9f70c1.patch?full_index=1"
    sha256 "1355ca875eb711169a8090a400eaf3ee4b73dcc8e4fa4833e976b21024187111"
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
