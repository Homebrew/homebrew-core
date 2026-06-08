class DyldHeaders < Formula
  desc "Header files for the dynamic linker"
  homepage "https://opensource.apple.com/"
  url "https://github.com/apple-oss-distributions/dyld/archive/refs/tags/dyld-1376.6.tar.gz"
  sha256 "962f38334e08ee96bfe166f5c4b4ade30b470fc7138af9cd14b054c101ddc8ec"
  license "APSL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "509050efede2c1f6b6c2e0ec12364d3700ef8ea233d493c827941a5dc0f8b162"
  end

  keg_only :provided_by_macos

  def install
    include.install Dir["include/*"]
  end
end
