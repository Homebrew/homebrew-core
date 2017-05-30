class Logtalk < Formula
  desc "Object-oriented logic programming language"
  homepage "http://logtalk.org"
  url "https://github.com/LogtalkDotOrg/logtalk3/archive/lgt3108stable.tar.gz"
  version "3.10.8"
  sha256 "b3adca03aa98a4c3df2cdc987ed2df805bfe3273f35a19b6df321b4b6f617be4"

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
