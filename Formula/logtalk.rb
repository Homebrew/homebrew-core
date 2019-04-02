class Logtalk < Formula
  desc "Object-oriented logic programming language"
  homepage "https://logtalk.org/"
  url "https://github.com/LogtalkDotOrg/logtalk3/archive/lgt3250stable.tar.gz"
  version "3.25.0"
  sha256 "8a185f4a6dbc3b0b322595d82f194bbd397ca70dc772af5ac62694e741ee1270"

  bottle do
    cellar :any_skip_relocation
    sha256 "10473d34fe7e542f93c9f759cfe12f911975eaf7e6c088307d8386f00da7ea75" => :mojave
    sha256 "0ebb74f7daa175173360a277d72d7165d4537d1825387d9d03e491d078100e78" => :high_sierra
    sha256 "8ff3172100f81eab17e01f14ba0640097968e80e4ff2da09f74c1062394a8657" => :sierra
  end

  depends_on "gnu-prolog"

  def install
    cd("scripts") { system "./install.sh", "-p", prefix }
  end
end
