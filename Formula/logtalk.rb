class Logtalk < Formula
  desc "Object-oriented logic programming language"
  homepage "http://logtalk.org"
  url "https://github.com/LogtalkDotOrg/logtalk3/archive/lgt3110stable.tar.gz"
  version "3.11.0"
  sha256 "efadb92c585d843efffd33d9bb9ebde6af0ff5a1e6f1a847da0e96540bd30fac"

  bottle do
    cellar :any_skip_relocation
    sha256 "bb033edd175b96c82ce094048cc87804b8da9ebab309649ce13b91fa9159f6fe" => :sierra
    sha256 "f6c5e35f46dd5970b40f13fe2c6f85d11bcf79ab1605b1758a7caa161968a17f" => :el_capitan
    sha256 "9f51212e5fa6733653ac6945a5ccdcb59b641689077ba0f30f812f5e1bbcabb0" => :yosemite
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
