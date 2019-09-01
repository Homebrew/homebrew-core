class Dylibbundler < Formula
  desc "Utility to bundle libraries into executables for macOS"
  homepage "https://github.com/auriamg/macdylibbundler"
  url "https://github.com/auriamg/macdylibbundler/archive/0.4.5-release.tar.gz"
  version "0.4.5"
  sha256 "cd41e45115371721e0aa94e70c457134acf49f6d5f6d359b5bae060fd876d887"
  head "https://github.com/auriamg/macdylibbundler.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f2554553b0c00165394e41ade50712f490331d7bf084792abc2cb4f12ae1164e" => :mojave
    sha256 "60b4e47bfbb3450f6901e6c104d37530940e9cc22abacaacbe37eb4539b820c6" => :high_sierra
    sha256 "c8f470a6e3c0c5eaf632dd384f5098f0e59f60ab2c873482424f7c6729a4fe07" => :sierra
  end

  def install
    system "make"
    bin.install "dylibbundler"
  end

  test do
    system "#{bin}/dylibbundler", "-h"
  end
end
