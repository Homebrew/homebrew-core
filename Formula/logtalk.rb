class Logtalk < Formula
  desc "Declarative object-oriented logic programming language"
  homepage "https://logtalk.org/"
  url "https://github.com/LogtalkDotOrg/logtalk3/archive/lgt3490stable.tar.gz"
  version "3.49.0"
  sha256 "bead3d035c114c262fd3c6b2273b4c34007888b4d11bde10f792fd7eecebd662"
  license "Apache-2.0"

  livecheck do
    url "https://logtalk.org/download.html"
    regex(/Latest stable version:.*?v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:      "8e9dd986617f15016de9ca3de1ff04c377339d67bafe657cbec9b9efb961f627"
    sha256 cellar: :any_skip_relocation, catalina:     "4fa6488a7be05070b60ca6b2f011ac1a3d6fdfebc9ca2ebfe493caca42a5b2e7"
    sha256 cellar: :any_skip_relocation, mojave:       "9eb6601db3d44df27539aeca4ba1c2fe55ee9d1365666b9e8fa750e5c9fdccac"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "51f75c13a017af59c9d386e29ec342848de012b91418ef985d4cc76e187856e6"
  end

  depends_on "gnu-prolog"

  def install
    cd("scripts") { system "./install.sh", "-p", prefix }
  end
end
