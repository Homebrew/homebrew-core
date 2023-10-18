class DyldHeaders < Formula
  desc "Header files for the dynamic linker"
  homepage "https://opensource.apple.com/"
  url "https://github.com/apple-oss-distributions/dyld/archive/refs/tags/dyld-1122.1.tar.gz"
  sha256 "a1892563701bc863cf24ac9f4195d69215422b1ed449b052e582685e53c7d371"
  license "APSL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2f71fc906411af56cd8d111c78b4fb073fcbb8617f74c5dd14667e48b00dbd47"
  end

  keg_only :provided_by_macos

  def install
    include.install Dir["include/*"]
  end
end
