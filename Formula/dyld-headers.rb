class DyldHeaders < Formula
  desc "Header files for the dynamic linker"
  homepage "https://opensource.apple.com/"
  url "https://opensource.apple.com/tarballs/dyld/dyld-635.2.tar.gz"
  sha256 "e891f256bf0cb570b7bc881a67de94944f973b97a37af5e3deeae7437d27dd37"

  bottle :unneeded

  keg_only :provided_by_macos

  def install
    include.install Dir["include/*"]
  end
end
