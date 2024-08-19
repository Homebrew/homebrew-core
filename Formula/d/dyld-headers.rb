class DyldHeaders < Formula
  desc "Header files for the dynamic linker"
  homepage "https://opensource.apple.com/"
  url "https://github.com/apple-oss-distributions/dyld/archive/refs/tags/dyld-1162.tar.gz"
  sha256 "b61c77ef784b68a734a58ee84e5fa3db7da90cddf7291d81e6c16a240a3c0457"
  license "APSL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "cbeb8be1288879abb472b2b761a88d4252c68c8334cdac79faa036e413e2ce62"
  end

  keg_only :provided_by_macos

  def install
    include.install Dir["include/*"]
  end
end
