class DyldHeaders < Formula
  desc "Header files for the dynamic linker"
  homepage "https://opensource.apple.com/"
  url "https://github.com/apple-oss-distributions/dyld/archive/refs/tags/dyld-1241.17.tar.gz"
  sha256 "77bf760f55880bb96759b4a4596c1021bc69cdfa4af72d6b65f90b65ba67c23c"
  license "APSL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1c1a120eeac00f9b11df5efd8d6e97ab3a424b9bc74fb5a6b65c55cd0162ed34"
  end

  keg_only :provided_by_macos

  def install
    include.install Dir["include/*"]
  end
end
