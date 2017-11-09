class Logtalk < Formula
  desc "Object-oriented logic programming language"
  homepage "http://logtalk.org"
  url "https://github.com/LogtalkDotOrg/logtalk3/archive/lgt3130stable.tar.gz"
  version "3.13.0"
  sha256 "8fd66df7c0ec1682121fb0e0f4e5eb2296caa3663b093c166b88c252737734d3"

  bottle do
    cellar :any_skip_relocation
    sha256 "612c3649aadc5c9fbf6b4793c785e7e67d567df3e2a917034db44b4c55b673e1" => :high_sierra
    sha256 "e572ad9e4e49ea055ef6bb76a55b81a282cbdbb0c0d236ca22ee9ef1da1f9163" => :sierra
    sha256 "89acc8982d080f8cf7b91604b57061fa90c2bfb577c908da23b725923ee372f8" => :el_capitan
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
