class Logtalk < Formula
  desc "Object-oriented logic programming language"
  homepage "http://logtalk.org"
  url "https://github.com/LogtalkDotOrg/logtalk3/archive/lgt3070stable.tar.gz"
  version "3.07.0"
  sha256 "e84042415b781c5946498e4d378c33714963c2a2454c8b6c3576ce2e450d0a28"

  bottle do
    cellar :any_skip_relocation
    sha256 "ee5251fe0985273e8b0d30a6456eee3a0f74f277b0fe2647249a196a0c622075" => :sierra
    sha256 "60c1a91c0780e01bbe4506c58645254ca3d7ef69646245834e3891946cc9b582" => :el_capitan
    sha256 "8cf2388939520f59ce94b73f3b4bb1d0b2cd4b5b8de51c5b7588b246fbcb40b1" => :yosemite
    sha256 "15a0821a53dd2dcd33d4b87ab666809752c0ae623cdd52aec1a2f16ecfbb6bb2" => :mavericks
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
