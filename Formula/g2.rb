class G2 < Formula
  desc "Friendly git client"
  homepage "https://orefalo.github.io/g2/"
  url "https://github.com/orefalo/g2/archive/v1.1.tar.gz"
  sha256 "bc534a4cb97be200ba4e3cc27510d8739382bb4c574e3cf121f157c6415bdfba"

  head "https://github.com/orefalo/g2.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6bd5de5c1e1335c1be168bf5eec800c8ac5d0b4d16534a7e686d9c4e8d396417" => :sierra
    sha256 "45c2029c3fc914866ba32966a78cba39b8415ba7f191cd1eaaf604db798b6d3f" => :el_capitan
    sha256 "5645b9c9401aa9f047082612de0e7bbd119ff7fd9fd49d94d45ce2adfbbfb69a" => :yosemite
    sha256 "41f5cd09949d53b4d46dfab4a17d5f3d77f65978ebb5e04e3433f9386d7846b4" => :mavericks
  end

  def install
    system "make", "prefix=#{prefix}", "install"
  end

  def caveats; <<-EOS.undent
    To complete the installation:
      . #{prefix}/g2-install.sh

    NOTE: This will install a new ~/.gitconfig, backing up any existing
    file first. For more information view:
      #{prefix}/README.md
    EOS
  end
end
