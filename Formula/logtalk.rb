class Logtalk < Formula
  desc "Object-oriented logic programming language"
  homepage "http://logtalk.org"
  url "https://github.com/LogtalkDotOrg/logtalk3/archive/lgt3050stable.tar.gz"
  version "3.06.0"
  sha256 "4adb097bf27fc8e90e1df534bf5ef290a4cc96fcf8f60bc0a7dc5dcb0098fb44"

  bottle do
    cellar :any_skip_relocation
    sha256 "b5e6b7f78420431803face5a37248e3c0b6a38a1f0583883ffbee806d8e478e1" => :el_capitan
    sha256 "8da71c575899d9556912451e0afef81a14cc40171317227e58437641bc79fb7f" => :yosemite
    sha256 "8ccc08a282695eb8d1c6c15304919f01cf1ab372742d5cbab4a20afabc9ff906" => :mavericks
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
