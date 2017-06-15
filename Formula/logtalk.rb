class Logtalk < Formula
  desc "Object-oriented logic programming language"
  homepage "http://logtalk.org"
  url "https://github.com/LogtalkDotOrg/logtalk3/archive/lgt3109stable.tar.gz"
  version "3.10.9"
  sha256 "500a538d4217792f00f69dbbf7ce3d7d177c849dbee45f65814e7c5edf5e97b6"

  bottle do
    cellar :any_skip_relocation
    sha256 "2d6db805da15da72fe93f3b103b47926417d845c350c165f82a32a9d9b748f0b" => :sierra
    sha256 "ee4c6dedc0df5354b8b6d74cccdd3077abf6d80b1bc52ca8035b744095d51f0e" => :el_capitan
    sha256 "17d3eb5bd470385c463e8b95f979f2c1d2b5719934f49a292413eab4df95fcfe" => :yosemite
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
