class Logtalk < Formula
  desc "Object-oriented logic programming language"
  homepage "http://logtalk.org"
  url "https://github.com/LogtalkDotOrg/logtalk3/archive/lgt3080stable.tar.gz"
  version "3.08.0"
  sha256 "84b87693ac89dc2229b84aab8207655de06714d3076f7ce54ba80dff8f7c7172"

  bottle do
    cellar :any_skip_relocation
    sha256 "f6072c376ed41266fa378ffa2b378ad80eecaa0d7155463dbdd2f56cf8360a04" => :sierra
    sha256 "e93f6e51952d9fae232867f9db8e984f3ed9c212d469c76180ddbdb89d4f3654" => :el_capitan
    sha256 "4ef807c1bab1828f3d910d1364570fd6e3995bb3c5cdf514d40d00787b8e9fe8" => :yosemite
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
