class Logtalk < Formula
  desc "Object-oriented logic programming language"
  homepage "http://logtalk.org"
  url "https://github.com/LogtalkDotOrg/logtalk3/archive/lgt3120stable.tar.gz"
  version "3.12.0"
  sha256 "a5d71db80200e0bd2fac3c0d4153a86fe0601f9f66f1763df423139420c3597a"

  bottle do
    cellar :any_skip_relocation
    sha256 "f17cc41ffbd740190345f95437c76e783496a8a09151e8c578c7b36a831133a4" => :high_sierra
    sha256 "e34758d40b7d016b26e772373358ac1caf9d527d6b1dd42a5510cfcd7b61369a" => :sierra
    sha256 "0982c974b2c0bf85252ee07b2ad99eab0ec646603ad1d2eedf7ad94dfd5263f0" => :el_capitan
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
