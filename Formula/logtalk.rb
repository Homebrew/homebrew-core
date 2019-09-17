class Logtalk < Formula
  desc "Object-oriented logic programming language"
  homepage "https://logtalk.org/"
  url "https://github.com/LogtalkDotOrg/logtalk3/archive/lgt3300stable.tar.gz"
  version "3.30.0"
  sha256 "712a55d7829a46dddc85bb34f682efa3bdf5725f4e2d2bed578a1330436b56a1"

  bottle do
    cellar :any_skip_relocation
    sha256 "27a19c93a86a8b714362b76d15a34fc387bbe82c045f0b609b55cf5980bba7fd" => :mojave
    sha256 "7225b829e36b52369860a9dbdf26d81c35072a87fb18d648b414e17aed81afd7" => :high_sierra
    sha256 "a85858ecdc7dc82c069e4768dadaab8cc70e100fc396095b3ab76b5397bceae2" => :sierra
  end

  depends_on "gnu-prolog"

  def install
    cd("scripts") { system "./install.sh", "-p", prefix }
  end
end
