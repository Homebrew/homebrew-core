class Logtalk < Formula
  desc "Object-oriented logic programming language"
  homepage "https://logtalk.org/"
  url "https://github.com/LogtalkDotOrg/logtalk3/archive/lgt3240stable.tar.gz"
  version "3.24.0"
  sha256 "cb2e63194c14cc0f0fe23640ba0857c9a23f0b5afeb6ecb8a5d64a331a3fb370"

  bottle do
    cellar :any_skip_relocation
    sha256 "4a3bd2df39d8cabea5d7009c410060e1ed669a9123abc34182dcf6655a1a255b" => :mojave
    sha256 "99d8c4cdf66446dd4c2a316c85769e4148d10bd521de7e9fed453fcd0a541474" => :high_sierra
    sha256 "fc656a169ea113476f4f7e49661e63a9039b3ce6a6426923585305f48e090837" => :sierra
  end

  depends_on "gnu-prolog"

  def install
    cd("scripts") { system "./install.sh", "-p", prefix }
  end
end
