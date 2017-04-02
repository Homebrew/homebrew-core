class Jerm < Formula
  desc "Communication terminal through serial and TCP/IP interfaces"
  homepage "http://www.bsddiary.net/jerm/"
  url "http://www.bsddiary.net/jerm/jerm-8096.tar.gz"
  version "0.8096"
  sha256 "8a63e34a2c6a95a67110a7a39db401f7af75c5c142d86d3ba300a7b19cbcf0e9"

  bottle do
    cellar :any_skip_relocation
    sha256 "ee9a8a2e559bf9ab82ba413e8741759fed6d59cfe82a063c82b72b81a56cfe5e" => :sierra
    sha256 "5c8409bfdeba7b55199659f4b82b8df9ec2ca8685435703bf1ddff29f9e027e5" => :el_capitan
    sha256 "bce73bc0790565d58c129116833c2bf6dab677c95287036f4b3717a02792da12" => :yosemite
    sha256 "e7a2ed29af497e459175ac4b7bf9d4e0b9a367c653ee3d7798b316a95d8e5cbe" => :mavericks
  end

  def install
    system "make", "all"
    bin.install %w[jerm tiocdtr]
    man1.install Dir["*.1"]
  end
end
