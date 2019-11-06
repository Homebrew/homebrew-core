class Lxsplit < Formula
  desc "Tool for splitting or joining files"
  homepage "https://lxsplit.sourceforge.io/"
  url "https://downloads.sourceforge.net/lxsplit/lxsplit-0.2.4.tar.gz"
  sha256 "858fa939803b2eba97ccc5ec57011c4f4b613ff299abbdc51e2f921016845056"

  bottle do
    cellar :any_skip_relocation
    sha256 "8f2c02d85a1aec1e2ec692564896c668cb6d7c4cd28b0d3b1f08da1be7070b07" => :catalina
    sha256 "ffc9b9b7e9669e1cff8a46b3930d052ffa149179897134439b1228d8ee178777" => :mojave
    sha256 "da1b73f5843b77ce947ce546fb77a47f2c1b989efbf70fdd61b9d05f81a386b5" => :high_sierra
    sha256 "f4d271c94546ca73b9e5262ff53bf7b51dcde2a83998d5a2e4b663109f2f69d8" => :sierra
    sha256 "25699d54183a01f446015fb02521a50b3967ef2d250e56bb1fe3fd0a5aaec2e1" => :el_capitan
    sha256 "d7d8d9eb204599056a4e109c63114c90e3be797d2be700e114cc3675d8eba0bb" => :yosemite
    sha256 "da0ee88012d21dc120c7247fd856305fe14a213e38babcd39ab652af06483b7e" => :mavericks
  end

  def install
    bin.mkpath
    inreplace "Makefile", "/usr/local/bin", bin
    system "make"
    system "make", "install"
  end
end
