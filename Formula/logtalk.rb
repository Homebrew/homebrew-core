class Logtalk < Formula
  desc "Object-oriented logic programming language"
  homepage "http://logtalk.org"
  url "https://github.com/LogtalkDotOrg/logtalk3/archive/lgt3100stable.tar.gz"
  version "3.10.0"
  sha256 "333a5416015bc4419616f84926a86aa81e9d35dece3567283c2467e79b42475e"

  bottle do
    cellar :any_skip_relocation
    sha256 "7d09c47aafba48df8c2c26f4e14350aa9875059850620137dd6a842d7e3eddf6" => :sierra
    sha256 "10c54197ec69d02efec2d42299ef26e8f889eb9c3b008cb659d50c45057137e9" => :el_capitan
    sha256 "89595be20fb94334e43ac1e6d4928a4ca9986b5512ecef1a27f09952c7563c09" => :yosemite
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
