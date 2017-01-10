class ChrubyFish < Formula
  desc "Thin wrapper around chruby to make it work with the Fish shell"
  homepage "https://github.com/JeanMertz/chruby-fish#readme"
  url "https://github.com/JeanMertz/chruby-fish/archive/v0.8.1.tar.gz"
  sha256 "1a0fa95d6be5958edca31a80de3594a563de6f7d09213418db895dda6724c271"
  head "https://github.com/JeanMertz/chruby-fish.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "042cd9e456a4bf894ef9f40a47f1255cba1ab08020b1dc44476a8dea7658bd16" => :sierra
    sha256 "042cd9e456a4bf894ef9f40a47f1255cba1ab08020b1dc44476a8dea7658bd16" => :el_capitan
    sha256 "042cd9e456a4bf894ef9f40a47f1255cba1ab08020b1dc44476a8dea7658bd16" => :yosemite
  end

  depends_on "fish" => :recommended
  depends_on "chruby" => :recommended

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match /chruby-fish/, shell_output("fish -c '. #{share}/chruby/chruby.fish; chruby --version'")
  end
end
