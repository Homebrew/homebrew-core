require "language/haskell"

class Komposition < Formula
  include Language::Haskell::Cabal

  desc "Video editor built for screencasters"
  homepage "https://github.com/owickstrom/komposition"
  url "https://github.com/owickstrom/komposition/archive/v0.2.0.tar.gz"
  sha256 "cedb41c68866f8d6a87579f566909fcd32697b03f66c0e2a700a94b6a9263b88"
  head "https://github.com/owickstrom/komposition.git"

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
    # The --allow-newer=base may be removed when the ffmpeg-light
    # bound on base is relaxed, or when Homebrew moves to Cabal 3
    # builds.
    install_cabal_package "--allow-newer=base", :using => ["alex", "happy"]
  end

  test do
    output = shell_output "#{bin}/komposition doesnotexist 2>&1"
    assert_match "[ERROR] Opening existing project failed: ProjectDirectoryDoesNotExist \"doesnotexist\"", output
  end
end
