class Logtalk < Formula
  desc "Object-oriented logic programming language"
  homepage "https://logtalk.org/"
  url "https://github.com/LogtalkDotOrg/logtalk3/archive/lgt3140stable.tar.gz"
  version "3.14.0"
  sha256 "53308f726616e5c6ea1ff76c26c08a3e402a32aaa7f8a6f7fbd59828441ee390"

  bottle do
    cellar :any_skip_relocation
    sha256 "9a2b75fb6e3ebac910816d04ef7bb1540718360d4996197a212d096478c69cb5" => :high_sierra
    sha256 "87e803892287f2a81f9a982ac28f914b3695a4f30c478fb44a18240ec5a1455b" => :sierra
    sha256 "8c6aa172454a014e3888cc405560b8d553be9ac6253366bf92c4fe2d375d4e0d" => :el_capitan
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
