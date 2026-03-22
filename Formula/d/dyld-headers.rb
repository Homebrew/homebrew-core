class DyldHeaders < Formula
  desc "Header files for the dynamic linker"
  homepage "https://opensource.apple.com/"
  url "https://github.com/apple-oss-distributions/dyld/archive/refs/tags/dyld-1340.tar.gz"
  sha256 "662a1d8aa1066d5df39d3da571d36a9ebe4b317ac9e88694f324fe44b667fa74"
  license "APSL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "dabb64e14892221962e5884470922b8511558161e433ff1d3cafa7a2a6555726"
  end

  keg_only :provided_by_macos

  def install
    include.install Dir["include/*"]
  end
end
