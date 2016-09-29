class GitNumber < Formula
  desc "Use numbers for dealing with files in git"
  homepage "https://github.com/holygeek/git-number"
  url "https://github.com/holygeek/git-number/archive/1.0.0a.tar.gz"
  sha256 "710804466860fdb6f985c0a1268887230c4c1ff708584b19e385bbaec872f4f5"
  version "1.0.0a"

  bottle do
    cellar :any_skip_relocation
    sha256 "4e961bbed534ae3bec5661574f333aa0217da960920ccf956421487a27d5e6e5" => :sierra
    sha256 "e4a73d3be05fb32a693918d9ccd7c13d995abbc29df57a91af8bb572420bc82c" => :el_capitan
    sha256 "aab690794b8908b84a02c8586831aa13bcdf4129d38fcbd9113e297b6b2c00d4" => :yosemite
    sha256 "a8775c026b9f5ff48b938c61d382aa972d54ee681a3ae96aa523156ca4242af6" => :mavericks
  end

  def install
    system "make", "test"
    system "make", "prefix=#{prefix}", "install"
  end
end
