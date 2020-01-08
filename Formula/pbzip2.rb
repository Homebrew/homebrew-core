class Pbzip2 < Formula
  desc "Parallel bzip2"
  homepage "https://web.archive.org/web/20180226093549/compression.ca/pbzip2/"
  url "https://launchpad.net/pbzip2/1.1/1.1.13/+download/pbzip2-1.1.13.tar.gz"
  sha256 "8fd13eaaa266f7ee91f85c1ea97c86d9c9cc985969db9059cdebcb1e1b7bdbe6"

  bottle do
    cellar :any_skip_relocation
    sha256 "57c1c1065cd29ee37187b87705adfb73b84d114fc46408d4690024f3a29ac837" => :catalina
    sha256 "5594212d69f619f7fa59cfec23ce2c6eefa0f8c69d5e77cdd84cf9e2478d0d51" => :mojave
    sha256 "d72e618d7301937ab6a392e1ef3d9ed1f8d5380cd6516ea17b4e4bde11eea9a7" => :high_sierra
    sha256 "c15b9c38b5302286033e54ff4be006c3b31ccb179f96641e44f1126958527d7e" => :sierra
    sha256 "be653d724b6f061cb9939dbdbf457aebc275e16dbf599f598b9ff3999fdd5db3" => :el_capitan
    sha256 "ad103aef3e2d72293cfed3fcc42999afee9b4fc332f8319e3c079758215411c9" => :yosemite
  end

  def install
    system "make", "PREFIX=#{prefix}",
                   "CC=#{ENV.cxx}",
                   "CFLAGS=#{ENV.cflags}",
                   "PREFIX=#{prefix}",
                   "install"
  end

  test do
    system "#{bin}/pbzip2", "--version"
  end
end
