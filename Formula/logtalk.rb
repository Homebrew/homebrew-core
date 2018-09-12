class Logtalk < Formula
  desc "Object-oriented logic programming language"
  homepage "https://logtalk.org/"
  url "https://github.com/LogtalkDotOrg/logtalk3/archive/lgt3200stable.tar.gz"
  version "3.20.0"
  sha256 "800b66ad4b7d803f06c666430c8586e4f40b1cc78ffe6e66b223e1705a7839eb"

  bottle do
    cellar :any_skip_relocation
    sha256 "9650836cc63b908f6e156809df579af5b120b3bbe3ee3bf1610debd452b3800b" => :mojave
    sha256 "0f6857861e6b9a05a236956929ff74e5f2749e8195ff21033f9673ca398992bc" => :high_sierra
    sha256 "0f6857861e6b9a05a236956929ff74e5f2749e8195ff21033f9673ca398992bc" => :sierra
    sha256 "dba02ef1ea3cfbe61cf2dee60595649066bc4fd56d14879c726a8d7f0167b2a5" => :el_capitan
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
