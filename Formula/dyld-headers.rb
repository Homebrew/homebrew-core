class DyldHeaders < Formula
  desc "Header files for the dynamic linker"
  homepage "https://opensource.apple.com/"
  url "https://github.com/apple-oss-distributions/dyld/archive/refs/tags/dyld-957.tar.gz"
  sha256 "4a632883e252f85f0aee16c9d07a47116315ee6a348ef4e7849b612112e55d19"
  license "APSL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "051302c52294864242a6633a6147cbd7ab3ce0ca356f0c397ced58339057477a"
  end

  keg_only :provided_by_macos

  def install
    include.install Dir["include/*"]
  end
end
