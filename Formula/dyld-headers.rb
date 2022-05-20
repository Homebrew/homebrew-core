class DyldHeaders < Formula
  desc "Header files for the dynamic linker"
  homepage "https://opensource.apple.com/"
  url "https://github.com/apple-oss-distributions/dyld/archive/refs/tags/dyld-955.tar.gz"
  sha256 "3cf4e0b964bf1c1cb5daa78a21ea692b82358d7c5f94ebd876c14f8ca4473f43"
  license "APSL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "bbc47bd6942602a943962154dc4a3abaf7a4499c9eb5ef4f8d9fda85e81dbff9"
  end

  keg_only :provided_by_macos

  def install
    include.install Dir["include/*"]
  end
end
