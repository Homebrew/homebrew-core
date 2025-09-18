class DyldHeaders < Formula
  desc "Header files for the dynamic linker"
  homepage "https://opensource.apple.com/"
  url "https://github.com/apple-oss-distributions/dyld/archive/refs/tags/dyld-1286.10.tar.gz"
  sha256 "4edc2b4e8c51e7d1b67b27f38036a3f9800d209b8a23aa4d51bfd674d0bda14c"
  license "APSL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "184f510f94f910e102460001de27b691ade9600b375344f8416f68fc0674b3bf"
  end

  keg_only :provided_by_macos

  def install
    include.install Dir["include/*"]
  end
end
