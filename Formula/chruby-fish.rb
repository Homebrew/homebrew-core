class ChrubyFish < Formula
  desc "Thin wrapper around chruby to make it work with the Fish shell"
  homepage "https://github.com/JeanMertz/chruby-fish#readme"
  url "https://github.com/JeanMertz/chruby-fish/archive/v0.8.2.tar.gz"
  sha256 "e3726d39da219f5339f86302f7b5d7b62ca96570ddfcc3976595f1d62e3b34e1"
  head "https://github.com/JeanMertz/chruby-fish.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "60d767ee3b1dc1406791fd19a8280f5d933efece6102bbc1131917f90ce3e292" => :mojave
    sha256 "3b34f5c1170d17701bebffde714c48679a076dc67293aab04dd5b8d4e7fa66f2" => :high_sierra
    sha256 "042cd9e456a4bf894ef9f40a47f1255cba1ab08020b1dc44476a8dea7658bd16" => :sierra
    sha256 "042cd9e456a4bf894ef9f40a47f1255cba1ab08020b1dc44476a8dea7658bd16" => :el_capitan
    sha256 "042cd9e456a4bf894ef9f40a47f1255cba1ab08020b1dc44476a8dea7658bd16" => :yosemite
  end

  depends_on "chruby"
  depends_on "fish"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match /chruby-fish/, shell_output("fish -c '. #{share}/chruby/chruby.fish; chruby --version'")
  end
end
