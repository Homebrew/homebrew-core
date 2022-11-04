class DyldHeaders < Formula
  desc "Header files for the dynamic linker"
  homepage "https://opensource.apple.com/"
  url "https://github.com/apple-oss-distributions/dyld/archive/refs/tags/dyld-1042.1.tar.gz"
  sha256 "5ff902c50c78e809e90fb92038b86e531aafbc6dff36d254d6548ce6d41a0aa8"
  license "APSL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6aa5f4c387210e85ca094122d01968cdfc861b19233f3266969e723d2b2ab2b0"
  end

  keg_only :provided_by_macos

  def install
    include.install Dir["include/*"]
  end
end
