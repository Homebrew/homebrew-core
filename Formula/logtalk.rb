class Logtalk < Formula
  desc "Object-oriented logic programming language"
  homepage "http://logtalk.org"
  url "https://github.com/LogtalkDotOrg/logtalk3/archive/lgt3090stable.tar.gz"
  version "3.09.0"
  sha256 "5a9bbfc24847936e072e9783678ff0f10657d7d3da627485a1a278f6fac20434"

  bottle do
    cellar :any_skip_relocation
    sha256 "a640a94a38e8692603b1b1b7672fd9cb672005eba94234e83c430a9f11ab235c" => :sierra
    sha256 "cadd3735f5e5525ec44bbd7f407b93ca13f1be0255db1bc04d127001ffdda740" => :el_capitan
    sha256 "6c2590aac04fe75ff2cb8508930f638c40a737e132c4253f48d45ac51448a606" => :yosemite
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
