class Logtalk < Formula
  desc "Object-oriented logic programming language"
  homepage "http://logtalk.org"
  url "https://github.com/LogtalkDotOrg/logtalk3/archive/lgt3104stable.tar.gz"
  version "3.10.4"
  sha256 "96af56d1b7eb8a86b69b6653f5f90f5ecb9bf1af762f782badbad06a4835f685"

  bottle do
    cellar :any_skip_relocation
    sha256 "33900bcb8b94de6979950d05b9c23043cbac6b6062e53c31f3fe4d5a98755c9a" => :sierra
    sha256 "e15e6acb7f9c0e1cccbdb474d1a5f45f1055b57b1edb7dedd1986f1b719b65c0" => :el_capitan
    sha256 "754ca166d87e0dd6e7f22aa372feeeeada593aed3d628acdaf201f76f8c9fa4d" => :yosemite
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
