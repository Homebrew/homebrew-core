class DyldHeaders < Formula
  desc "Header files for the dynamic linker"
  homepage "https://opensource.apple.com/"
  url "https://github.com/apple-oss-distributions/dyld/archive/refs/tags/dyld-1125.5.tar.gz"
  sha256 "312990a7bf1fa6a9a86c9990d9b7130e451a44697f516e4aacef35f6789112d4"
  license "APSL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "cd228895b59ad7f66d3afdb9238092c0913515ad37c0207e1afbe6c50232fda6"
  end

  keg_only :provided_by_macos

  def install
    include.install Dir["include/*"]
  end
end
