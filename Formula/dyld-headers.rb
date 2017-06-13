class DyldHeaders < Formula
  desc "Header files for the dynamic linker"
  homepage "https://opensource.apple.com/"
  url "https://opensource.apple.com/tarballs/dyld/dyld-360.18.tar.gz"
  sha256 "a5bec8c2e3bded111aec7e447b35c110038e822f95e11e55b9a4d331fbaeff08"

  bottle :unneeded

  keg_only :provided_by_osx

  def install
    include.install Dir["include/*"]
  end
end
