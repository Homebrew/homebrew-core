class Ptex < Formula
  desc "Texture mapping system"
  homepage "http://ptex.us"
  url "https://github.com/wdas/ptex/archive/v2.1.28.tar.gz"
  sha256 "919af3cc56a7617079757bac5c0202f4375acf21861a3990e313739e56a6142c"

  bottle do
    cellar :any
    sha256 "38572ce52fb672e652c3ac27a9704eebabef60b673e6e7a21d11ae14b565a75e" => :sierra
    sha256 "fd5994b3ab6f116c242a997a186a39a149a4ad2318d43cc587456f8e12797d87" => :el_capitan
    sha256 "71d3eee613d7825583ee7eb673928e6ad6a8876310f6628cb70f8ecb82ff53fb" => :yosemite
    sha256 "ef6b1d4b5969dd1512299cdc9e00e520464792ca37081a16ea4d77abcb253dcb" => :mavericks
  end

  depends_on "cmake" => :build

  def install
    system "make", "prefix=#{prefix}"
    system "make", "test"
    system "make", "install"
  end
end
