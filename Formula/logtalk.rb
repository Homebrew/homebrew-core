class Logtalk < Formula
  desc "Object-oriented logic programming language"
  homepage "http://logtalk.org"
  url "https://github.com/LogtalkDotOrg/logtalk3/archive/lgt3107stable.tar.gz"
  version "3.10.7"
  sha256 "614ae6e4a5a064b90c171d5804c40d9739e9d919b4444da5f26a57dd0eb23497"

  bottle do
    cellar :any_skip_relocation
    sha256 "bf461198e884956a69b201bd6ffdd33a5b6b75aa677f17faf02a822f0e4dd269" => :sierra
    sha256 "c65ef396ef31af9948e09fbc56353ad028e4e3e182067f806219ab1ade332c3e" => :el_capitan
    sha256 "c65ef396ef31af9948e09fbc56353ad028e4e3e182067f806219ab1ade332c3e" => :yosemite
  end

  option "with-swi-prolog", "Build using SWI Prolog as backend"
  option "with-gnu-prolog", "Build using GNU Prolog as backend (Default)"

  deprecated_option "swi-prolog" => "with-swi-prolog"
  deprecated_option "gnu-prolog" => "with-gnu-prolog"

  if build.with? "swi-prolog"
    depends_on "swi-prolog"
  else
    depends_on "gnu-prolog"
  end

  def install
    cd("scripts") { system "./install.sh", "-p", prefix }
  end
end
