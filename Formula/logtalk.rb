class Logtalk < Formula
  desc "Object-oriented logic programming language"
  homepage "http://logtalk.org"
  url "https://github.com/LogtalkDotOrg/logtalk3/archive/lgt3109stable.tar.gz"
  version "3.10.9"
  sha256 "500a538d4217792f00f69dbbf7ce3d7d177c849dbee45f65814e7c5edf5e97b6"

  bottle do
    cellar :any_skip_relocation
    sha256 "60d281f5ecf943ee2ac1b1d5607d99c9233655e11b6e3813e65df7c8e365ffe2" => :sierra
    sha256 "e78670f6a98911f9df5a3c92a101dbb6983c63c0c88ffbff97ee28e866e2f76f" => :el_capitan
    sha256 "a084692e5c0cf55a584d1390ee856733d67b3f490ea8eff10a1f2f0fdcfbe5ae" => :yosemite
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
