class DyldHeaders < Formula
  desc "Header files for the dynamic linker"
  homepage "https://opensource.apple.com/"
  url "https://opensource.apple.com/tarballs/dyld/dyld-832.7.3.tar.gz"
  sha256 "d2efd46d12bf63e724315760c50cb53b1f08ffb09f3b549fb07139b78dd26db4"
  license "APSL-2.0"

  livecheck do
    url "https://opensource.apple.com/tarballs/dyld/"
    regex(/href=.*?dyld[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle :unneeded

  keg_only :provided_by_macos

  def install
    include.install Dir["include/*"]
  end
end
