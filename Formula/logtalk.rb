class Logtalk < Formula
  desc "Object-oriented logic programming language"
  homepage "http://logtalk.org"
  url "https://github.com/LogtalkDotOrg/logtalk3/archive/lgt3062stable.tar.gz"
  version "3.06.2"
  sha256 "9ab1d7dd19fb22820ef1ef29656d1008d8574101b0e5d451817b2fa7d79ed464"

  bottle do
    cellar :any_skip_relocation
    sha256 "b857a78212dd7105eb3c7784a7fcb6cc31d7b75d286dd358727b65ff678223b1" => :el_capitan
    sha256 "d1085d2d1a5fecccc2201ce6c3abbb6a46b723e0257f5ba787b945f9d52ea13f" => :yosemite
    sha256 "79cda09a052f143661dcfd7fc8e71227005403bd7aed711e5952d3dd08acdb0c" => :mavericks
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
