class Logtalk < Formula
  desc "Object-oriented logic programming language"
  homepage "http://logtalk.org"
  url "https://github.com/LogtalkDotOrg/logtalk3/archive/lgt3108stable.tar.gz"
  version "3.10.8"
  sha256 "b3adca03aa98a4c3df2cdc987ed2df805bfe3273f35a19b6df321b4b6f617be4"

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
