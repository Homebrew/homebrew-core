class Logtalk < Formula
  desc "Object-oriented logic programming language"
  homepage "http://logtalk.org"
  url "https://github.com/LogtalkDotOrg/logtalk3/archive/lgt3103stable.tar.gz"
  version "3.10.3"
  sha256 "fad5809aabbaba8d4df1895c19dba64d14b1b08d64375da08e12d3673f294a29"

  bottle do
    cellar :any_skip_relocation
    sha256 "b15966f40b59a92ea22498e510c5ea76b3493c9cbff4ba7865f35080fa4be255" => :sierra
    sha256 "a778a2a3c4aebbdbe57e882e03098066936f4df9e5968edf664d4d8de668a42d" => :el_capitan
    sha256 "b3edce01af4190fd41d09dafbac751da4526004d8707ba09b37ec36a207913f7" => :yosemite
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
