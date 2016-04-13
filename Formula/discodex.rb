class Discodex < Formula
  desc "Distributed indices for disco"
  homepage "https://github.com/discoproject/discodex"
  url "https://github.com/discoproject/discodex/archive/fa3fa57aa9fcd9c2bd3b4cd2233dc0d051dafc2b.tar.gz"
  version "2012-01-10" # No tags in the project; using date of last commit as a proxy
  sha256 "552346943a7a0b561602f59736b678f4bd43ca505b0e3484699b3770d6aae485"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "db8480576b20c59fbc2d7ff4bd23cd3cad3ac70df746604992f28328ebb3eedf" => :yosemite
    sha256 "0baf75b7d7087763907bbbfc7f23e3985393a4e941b66f0d3595cd22b7fbbb29" => :mavericks
  end

  depends_on "disco"

  def install
    # The make target only installs python libs; must manually install the rest
    system "make", "install", "prefix=#{prefix}"
    prefix.install(%w[bin doc])
  end
end
