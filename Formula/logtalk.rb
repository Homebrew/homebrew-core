class Logtalk < Formula
  desc "Declarative object-oriented logic programming language"
  homepage "https://logtalk.org/"
  url "https://github.com/LogtalkDotOrg/logtalk3/archive/lgt3380stable.tar.gz"
  version "3.38.0"
  sha256 "201c19fbcdd017ab376719ce052afba04263652f5766f2a423de2554814ecda8"

  bottle do
    cellar :any_skip_relocation
    sha256 "e1d7eca723190d816a077cfff91bbcb739967357671d64e5d78b77d90d5ed8fd" => :catalina
    sha256 "fd4d97658f25c9b9e166957cc14b2f9fe4381811470023f888a40e1bab157cc8" => :mojave
    sha256 "ad6f0a3f4813ea64a7ff7bd2dc162d594eb7d365c4df65c70e37a4fd67088489" => :high_sierra
  end

  depends_on "gnu-prolog"

  def install
    cd("scripts") { system "./install.sh", "-p", prefix }
  end
end
