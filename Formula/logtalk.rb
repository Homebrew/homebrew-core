class Logtalk < Formula
  desc "Object-oriented logic programming language"
  homepage "https://logtalk.org/"
  url "https://github.com/LogtalkDotOrg/logtalk3/archive/lgt3190stable.tar.gz"
  version "3.19.0"
  sha256 "d094a920e5238fb441ed1e009cacb7e454bafe1a56d6a680cc65e88e78e4d6aa"

  bottle do
    cellar :any_skip_relocation
    sha256 "f40c4264d9fca2a1150d11aca1f87084ea117a0f5506e66e10270e14fc18ffa1" => :high_sierra
    sha256 "70de3fe49de350e4cbeba478e169fc7328c15c6c1aedeefaf9613370af752f34" => :sierra
    sha256 "34cfb0bded918ff8110e79d1631009ea3f1707e8438bc6f4085e5e1994b8a761" => :el_capitan
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
