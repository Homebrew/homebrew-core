class DyldHeaders < Formula
  desc "Header files for the dynamic linker"
  homepage "https://opensource.apple.com/"
  url "https://opensource.apple.com/tarballs/dyld/dyld-852.2.tar.gz"
  sha256 "f38e62fa9d3aec0bbc487cc27bf141b060e163195878c2dde31cb54609e436c4"
  license "APSL-2.0"

  livecheck do
    url "https://opensource.apple.com/tarballs/dyld/"
    regex(/href=.*?dyld[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "90dbbbc915962b9c063da9a85b993c4266eddf80c1c36ff69917e9ca49424afb"
  end

  keg_only :provided_by_macos

  def install
    include.install Dir["include/*"]
  end
end
