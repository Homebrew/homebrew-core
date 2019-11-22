class FuzzyFind < Formula
  desc "Fuzzy filename finder matching across directories as well as files"
  homepage "https://github.com/silentbicycle/ff"
  url "https://github.com/silentbicycle/ff/archive/v0.6-flag-features.tar.gz"
  version "0.6.0"
  sha256 "104300ba16af18d60ef3c11d70d2ec2a95ddf38632d08e4f99644050db6035cb"
  head "https://github.com/silentbicycle/ff.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4e58e0ac23df5dbd26787238c0160716db8eb673b4a62625a9edcb4ceaf38eac" => :catalina
    sha256 "1a7bddb6228630cd27bd08863e41eaa01211dae1e5d409dd4ea9777c1599057d" => :mojave
    sha256 "b3f47d3bfd49f76960e5979fd4ef898c848e73f7f8da758b71c7eefe3f585fe0" => :high_sierra
    sha256 "feefa3913b9b1df2d8b283fdd55abd1de9ee924633d8e157142cce4980572ffb" => :sierra
    sha256 "7db1b187adfcb7ce37842891ffca5eec3ca25bed5441944cbeb1e08bc6d52a66" => :el_capitan
    sha256 "1b447f73c929866935af122bec4c15390f0001f049a0c737880fcfd4d7bafdb2" => :yosemite
    sha256 "75aa5bedb0bd3e2869f24f1363b02ddf88f7612549c97b8f93f5d7aae0e42e63" => :mavericks
  end

  def install
    system "make"
    bin.install "ff"
    man1.install "ff.1"
    elisp.install "fuzzy-find.el"
  end

  test do
    system bin/"ff", "-t"
  end
end
