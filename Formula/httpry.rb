class Httpry < Formula
  desc "Packet sniffer for displaying and logging HTTP traffic"
  homepage "https://github.com/jbittel/httpry"
  url "https://github.com/jbittel/httpry/archive/httpry-0.1.8.tar.gz"
  sha256 "b3bcbec3fc6b72342022e940de184729d9cdecb30aa754a2c994073447468cf0"
  head "https://github.com/jbittel/httpry.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "322f399002eec5d9116942db65d231d7eed5bb1b46e9959cdb48c6eb10f41339" => :catalina
    sha256 "32bdf2c6b873fc531455da9f4658746c650203a017c8b367172efde8aa93f9ba" => :mojave
    sha256 "349ba4f39066cb02c151ab0f274f6bb9f4ee2cf558abdb2c5a3ecf0e563874fc" => :high_sierra
    sha256 "71014794d2a136fea229dd19d6fe7dc136037c074a817d70bd7b13713653f19f" => :sierra
    sha256 "56d6a77e429bf9dde3d5e5edb9959fc7ed913430236cf628e0aec6445c07c85a" => :el_capitan
    sha256 "af0deb9d79e72df6369f57ed1050abeb70c62f77ab481232b556ba6da5ace66c" => :yosemite
    sha256 "ec016612be65aa5761213134d211f9bee121d8904dae9b9d73ebfc37d4de3cea" => :mavericks
  end

  uses_from_macos "libpcap"

  def install
    system "make"
    bin.install "httpry"
    man1.install "httpry.1"
    doc.install Dir["doc/*"]
  end

  test do
    system bin/"httpry", "-h"
  end
end
