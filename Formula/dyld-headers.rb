class DyldHeaders < Formula
  desc "Header files for the dynamic linker"
  homepage "https://opensource.apple.com/"
  url "https://github.com/apple-oss-distributions/dyld/archive/refs/tags/dyld-960.tar.gz"
  sha256 "4d5a878221ba7e099e1d8f0ff20e816fdad9fda3587e5c5c74e2a52fcc5c41d0"
  license "APSL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d524dce0754fef77305ada7afabfdd6133bcd6f3c83b6fc222b5f96ba27b9fd6"
  end

  keg_only :provided_by_macos

  def install
    include.install Dir["include/*"]
  end
end
