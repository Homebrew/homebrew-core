class Logtalk < Formula
  desc "Object-oriented logic programming language"
  homepage "http://logtalk.org"
  url "https://github.com/LogtalkDotOrg/logtalk3/archive/lgt3101stable.tar.gz"
  version "3.10.1"
  sha256 "1fc000bb957a20fd23833b3ce816ec534f53fe15017ac68ad16eee1e59baf5b8"

  bottle do
    cellar :any_skip_relocation
    sha256 "fb055fe8933050ebd0d38771328da8078ccf1ff2204304230a1b3c56ebaf59c2" => :sierra
    sha256 "ad8a39f047c25b804c097aa5f797a44f5de61b166fc85c7b0244cb939223378a" => :el_capitan
    sha256 "e211c0edd0175c1e6b1d1a9efdb23d14095dde2c574d4306cfbdbed36e3c6620" => :yosemite
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
