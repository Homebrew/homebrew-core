class Ptex < Formula
  desc "Texture mapping system"
  homepage "http://ptex.us"
  url "https://github.com/wdas/ptex/archive/v2.1.28.tar.gz"
  sha256 "919af3cc56a7617079757bac5c0202f4375acf21861a3990e313739e56a6142c"

  bottle do
    cellar :any
    sha256 "21982ca144f0dd43ce5a9c19d8f03bbd8732011f54d5617e093dc2b4e3999f6a" => :el_capitan
    sha256 "db0873c11cdcb3aace1facb63a5f97eb988b01e5654d34eb7d2199b139a1cbb4" => :yosemite
    sha256 "8a3488453c61feb9f81b8a1a81d4f6a696349d186709e3331748182135db551a" => :mavericks
  end

  depends_on "cmake" => :build

  def install
    system "make", "prefix=#{prefix}"
    system "make", "test"
    system "make", "install"
  end
end
