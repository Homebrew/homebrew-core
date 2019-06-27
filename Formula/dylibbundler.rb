class Dylibbundler < Formula
  desc "Utility to bundle libraries into executables for macOS"
  homepage "https://github.com/auriamg/macdylibbundler"
  url "https://github.com/auriamg/macdylibbundler/archive/0.4.5-release.tar.gz"
  version "0.4.5"
  sha256 "cd41e45115371721e0aa94e70c457134acf49f6d5f6d359b5bae060fd876d887"
  head "https://github.com/auriamg/macdylibbundler.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "4a5ee8ce4167301c5af472a253d615a67cdb276b58f961ef031845c3ec41fae7" => :mojave
    sha256 "54e0ca248e9030351699e9ff31ed02dfe280a9dd97e1446966d0c81b14f644ee" => :high_sierra
    sha256 "3d3297c9884ca982ce3a2ef9d31a53a1f96390268d0d9b378e3a954e0ad74996" => :sierra
    sha256 "5dff018e62a9787871e45f4ae976358cfc3f7f85972a0aa0d4e039f97d4b8e0f" => :el_capitan
    sha256 "eee9c829e932d8d25ded1e249bbf372ebfa0c9911dd3adc11a642184ecb6a6b7" => :yosemite
    sha256 "49c1600c49ff7b10bdae8dc7351496680a9a4fb434ce6cd7393d10008506393e" => :mavericks
  end

  def install
    system "make"
    bin.install "dylibbundler"
  end

  test do
    system "#{bin}/dylibbundler", "-h"
  end
end
