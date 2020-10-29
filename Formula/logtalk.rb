class Logtalk < Formula
  desc "Declarative object-oriented logic programming language"
  homepage "https://logtalk.org/"
  url "https://github.com/LogtalkDotOrg/logtalk3/archive/lgt3420stable.tar.gz"
  version "3.42.0"
  sha256 "4c9149dc8b9c57e9cb78cbdb98fb8d9701ff2772fbc996a7e28c309324ef678b"
  license "Apache-2.0"

  livecheck do
    url "https://logtalk.org/download.html"
    regex(/Latest stable version:.*?v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "6a178878387076d1b5df4ae68696be29f4a9a16ebb6046dd611085d96c362ae9" => :catalina
    sha256 "5a310b081fc098dd887482acce176b03087b31297cd0bfc77280fe6d42d014c3" => :mojave
    sha256 "8044706df53bcf87b54edd01d535b7f10c1f058202bf82e74cd5f93269c6c84b" => :high_sierra
  end

  depends_on "gnu-prolog"

  def install
    cd("scripts") { system "./install.sh", "-p", prefix }
  end
end
