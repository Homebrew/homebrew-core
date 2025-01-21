class DyldHeaders < Formula
  desc "Header files for the dynamic linker"
  homepage "https://opensource.apple.com/"
  url "https://github.com/apple-oss-distributions/dyld/archive/refs/tags/dyld-1235.2.tar.gz"
  sha256 "c49bc69500f411a0ecdf1dcfc753a62d464294d7b12b91ee0e40b3320eab4223"
  license "APSL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "62cd7fb6666667cca92cbd4022ca0a0232fcbcb1e50a33d4394e05779be60473"
  end

  keg_only :provided_by_macos

  def install
    include.install Dir["include/*"]
  end
end
