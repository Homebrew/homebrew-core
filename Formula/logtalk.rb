class Logtalk < Formula
  desc "Object-oriented logic programming language"
  homepage "https://logtalk.org/"
  url "https://github.com/LogtalkDotOrg/logtalk3/archive/lgt3210stable.tar.gz"
  version "3.21.0"
  sha256 "8f3edcbd0d6dacbb38cdf6b11c0578bf8082dfc09cafd171cd565cfcd638e23a"

  bottle do
    cellar :any_skip_relocation
    sha256 "9650836cc63b908f6e156809df579af5b120b3bbe3ee3bf1610debd452b3800b" => :mojave
    sha256 "0f6857861e6b9a05a236956929ff74e5f2749e8195ff21033f9673ca398992bc" => :high_sierra
    sha256 "0f6857861e6b9a05a236956929ff74e5f2749e8195ff21033f9673ca398992bc" => :sierra
    sha256 "dba02ef1ea3cfbe61cf2dee60595649066bc4fd56d14879c726a8d7f0167b2a5" => :el_capitan
  end

  depends_on "gnu-prolog"

  def install
    cd("scripts") { system "./install.sh", "-p", prefix }
  end
end
