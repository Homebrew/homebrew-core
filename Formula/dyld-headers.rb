class DyldHeaders < Formula
  desc "Header files for the dynamic linker"
  homepage "https://opensource.apple.com/"
  url "https://github.com/apple-oss-distributions/dyld/archive/refs/tags/dyld-957.tar.gz"
  sha256 "4a632883e252f85f0aee16c9d07a47116315ee6a348ef4e7849b612112e55d19"
  license "APSL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "bbc47bd6942602a943962154dc4a3abaf7a4499c9eb5ef4f8d9fda85e81dbff9"
  end

  keg_only :provided_by_macos

  def install
    include.install Dir["include/*"]
  end
end
