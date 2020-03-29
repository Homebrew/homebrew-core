class DyldHeaders < Formula
  desc "Header files for the dynamic linker"
  homepage "https://opensource.apple.com/"
  url "https://opensource.apple.com/tarballs/dyld/dyld-732.8.tar.gz"
  sha256 "52f6a0d3913548fcdd2e4b2deb50f2eeefc95c683a43f0daf9df2e9462d97d60"

  bottle :unneeded

  keg_only :provided_by_macos

  def install
    include.install Dir["include/*"]
  end
end
