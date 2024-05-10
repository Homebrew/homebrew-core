class DyldHeaders < Formula
  desc "Header files for the dynamic linker"
  homepage "https://opensource.apple.com/"
  url "https://github.com/apple-oss-distributions/dyld/archive/refs/tags/dyld-1160.6.tar.gz"
  sha256 "72e2d89bc7af55721408e0b79f7711ca18d3bc128c74dbe3c95049aae7a2f85d"
  license "APSL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "87e980046ea353df2527855420dcaa0f0f97a15b8e59c7f0a9e6c6fb66c66bbd"
  end

  keg_only :provided_by_macos

  def install
    include.install Dir["include/*"]
  end
end
