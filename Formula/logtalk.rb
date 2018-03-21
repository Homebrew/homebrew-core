class Logtalk < Formula
  desc "Object-oriented logic programming language"
  homepage "https://logtalk.org/"
  url "https://github.com/LogtalkDotOrg/logtalk3/archive/lgt3150stable.tar.gz"
  version "3.15.0"
  sha256 "8caf2c2f32b28b372ed22cc5496e142106651830d273ec195b30449af54b397d"

  bottle do
    cellar :any_skip_relocation
    sha256 "d83e4ee95fd39c16007daaae36db3ff3571c49d254a82c23503fb5ccdde0576b" => :high_sierra
    sha256 "5d1c69de3c5d1184b06bb6857ec3ac59d8515e24dc0cb036bc93e5706a9cfc12" => :sierra
    sha256 "f90bb2b497e3ae5d9873df7685607ef04217c32bad917e9577441cef0a3038d7" => :el_capitan
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
