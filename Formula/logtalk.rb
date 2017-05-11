class Logtalk < Formula
  desc "Object-oriented logic programming language"
  homepage "http://logtalk.org"
  url "https://github.com/LogtalkDotOrg/logtalk3/archive/lgt3107stable.tar.gz"
  version "3.10.7"
  sha256 "614ae6e4a5a064b90c171d5804c40d9739e9d919b4444da5f26a57dd0eb23497"

  bottle do
    cellar :any_skip_relocation
    sha256 "62bba6d8db05c05e1a472435475c6a82f3c707ef9d937008fa59e43c16c25958" => :sierra
    sha256 "796b84ceca3a8f7d268fbb9a78be4fcddb15b4c7c278beda24333dc88eb9c1c5" => :el_capitan
    sha256 "0a2eb60619e99de857f7bc9c02783e7bc4d0b74ee424ee7e1feecc8c2226aadf" => :yosemite
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
