class Dylibbundler < Formula
  desc "Utility to bundle libraries into executables for macOS"
  homepage "https://github.com/auriamg/macdylibbundler"
  url "https://github.com/auriamg/macdylibbundler/archive/1.0.4.tar.gz"
  sha256 "839c6a30be2c974bba70ab80faf8167713955bb010427662b14d4af7df8d5f19"
  license "MIT"
  head "https://github.com/auriamg/macdylibbundler.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "22cca810ba11f2a8138dd9180d2987bc04b259ed816665c97dbbb404bc7c0c61"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a2d6eca0963e1553807a61892bf4d789bcbf9b36411987eec6ea2a500a9d5aa4"
    sha256 cellar: :any_skip_relocation, monterey:       "5340336e6a50dc062a89d52a2ac8a36228471e3fe5d34a32e8e10af46b95e58d"
    sha256 cellar: :any_skip_relocation, big_sur:        "097f428274d356ef743f2f4b968c0c5c176fb637bc6c57a5500e6e08c75407f8"
    sha256 cellar: :any_skip_relocation, catalina:       "f79375380d2110fbb5e9e6c682aa95d05a8e7207d8a5aa4fe1789b82c7326e01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e857c47f4ca1f33326fd079d3a99ef6d8640ef5e383cab691d46d499ac8b17b7"
  end

  def install
    system "make"
    bin.install "dylibbundler"
  end

  test do
    system "#{bin}/dylibbundler", "-h"
  end
end
