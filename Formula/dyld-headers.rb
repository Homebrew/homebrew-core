class DyldHeaders < Formula
  desc "Header files for the dynamic linker"
  homepage "https://opensource.apple.com/"
  url "https://opensource.apple.com/tarballs/dyld/dyld-655.1.1.tar.gz"
  sha256 "8ca6e3cf0263d3f69dfa65e0846e2bed051b0cff92e796352ad178e7e4c92f1d"

  bottle :unneeded

  keg_only :provided_by_macos

  def install
    include.install Dir["include/*"]
  end
end
