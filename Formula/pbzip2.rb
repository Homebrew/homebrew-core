class Pbzip2 < Formula
  desc "Parallel bzip2"
  homepage "http://compression.ca/pbzip2/"
  url "https://launchpad.net/pbzip2/1.1/1.1.13/+download/pbzip2-1.1.13.tar.gz"
  sha256 "8fd13eaaa266f7ee91f85c1ea97c86d9c9cc985969db9059cdebcb1e1b7bdbe6"

  bottle do
    cellar :any_skip_relocation
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
end
