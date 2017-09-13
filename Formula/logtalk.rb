class Logtalk < Formula
  desc "Object-oriented logic programming language"
  homepage "http://logtalk.org"
  url "https://github.com/LogtalkDotOrg/logtalk3/archive/lgt3112stable.tar.gz"
  version "3.11.2"
  sha256 "ca9cbc5d5894743995a39d0b2a8e712c441895be7a4c53a47fd283164a655b59"

  bottle do
    cellar :any_skip_relocation
    sha256 "edd0b771c0f4e2ff8d6b5bef7cb79519be40473ec6e4a6086bdc5c9c3bfb123e" => :sierra
    sha256 "564dbec983d9c752df1749f562edd8f4c4d0205c3f0c8a95445da0a93e10bd0f" => :el_capitan
    sha256 "0f50f0bd02547b87f52a3124cb5d1a0bb4c6035a2e6b3a876e268ea5c8887f5e" => :yosemite
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
