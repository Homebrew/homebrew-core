class ChrubyFish < Formula
  desc "Thin wrapper around chruby to make it work with the Fish shell"
  homepage "https://github.com/JeanMertz/chruby-fish#readme"
  url "https://github.com/JeanMertz/chruby-fish/archive/v0.8.1.tar.gz"
  sha256 "1a0fa95d6be5958edca31a80de3594a563de6f7d09213418db895dda6724c271"
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
