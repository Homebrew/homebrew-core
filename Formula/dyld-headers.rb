class DyldHeaders < Formula
  desc "Header files for the dynamic linker"
  homepage "https://opensource.apple.com/"
  url "https://opensource.apple.com/tarballs/dyld/dyld-733.6.tar.gz"
  sha256 "cabbea38a188a3b3c57e3f5ecba2d0124aa5c1edc4676d814ac635410bf1c538"

  livecheck do
    url "https://opensource.apple.com/tarballs/dyld/"
    regex(/href=.*?dyld[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle :unneeded

  keg_only :provided_by_macos

  def install
    include.install Dir["include/*"]
  end
end
