class Dylibbundler < Formula
  desc "Utility to bundle libraries into executables for macOS"
  homepage "https://github.com/auriamg/macdylibbundler"
  url "https://github.com/auriamg/macdylibbundler/archive/1.0.0.tar.gz"
  sha256 "9e2c892f0cfd7e10cef9af1127fee6c18a4c391463b9fc50574667eec4ec2c60"
  license "MIT"
  head "https://github.com/auriamg/macdylibbundler.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "475b571e44abd0e57c924e004b94dba1fd1600b11fb6e7094afdab42406865d8"
    sha256 cellar: :any_skip_relocation, big_sur:       "2c4d2e3d71590903992d5735f32189c532533dffb3d1874f08932afe33c0e5b8"
    sha256 cellar: :any_skip_relocation, catalina:      "0794eea61309318e5aa8686a5781cbd5c534b1f9b481d38502a7343007cfe77e"
    sha256 cellar: :any_skip_relocation, mojave:        "f2554553b0c00165394e41ade50712f490331d7bf084792abc2cb4f12ae1164e"
    sha256 cellar: :any_skip_relocation, high_sierra:   "60b4e47bfbb3450f6901e6c104d37530940e9cc22abacaacbe37eb4539b820c6"
    sha256 cellar: :any_skip_relocation, sierra:        "c8f470a6e3c0c5eaf632dd384f5098f0e59f60ab2c873482424f7c6729a4fe07"
  end

  def install
    system "make"
    bin.install "dylibbundler"
  end

  test do
    system "#{bin}/dylibbundler", "-h"
  end
end
