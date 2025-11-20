class DyldHeaders < Formula
  desc "Header files for the dynamic linker"
  homepage "https://opensource.apple.com/"
  url "https://github.com/apple-oss-distributions/dyld/archive/refs/tags/dyld-1323.3.tar.gz"
  sha256 "9696c72b4800da6941adc51f26cc40629ccb9f965e78c1324bebaf219c43be75"
  license "APSL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "042663a1058cb1115b53fc0f3d5e2b5b2a79b49013c3a88707aac8987b88364d"
  end

  keg_only :provided_by_macos

  def install
    include.install Dir["include/*"]
  end
end
