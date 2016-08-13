class Logtalk < Formula
  desc "Object-oriented logic programming language"
  homepage "http://logtalk.org"
  url "https://github.com/LogtalkDotOrg/logtalk3/archive/lgt3062stable.tar.gz"
  version "3.06.2"
  sha256 "9ab1d7dd19fb22820ef1ef29656d1008d8574101b0e5d451817b2fa7d79ed464"

  bottle do
    cellar :any_skip_relocation
    sha256 "44c26e00e870cde7e7404200a455c7efdfed1a06c42a955c5f992cc1a708c126" => :el_capitan
    sha256 "01c6cbd81c9b6087f5f7068b94e60c46d2d23bd8c99c57580f740db96c98ea59" => :yosemite
    sha256 "c945caf15c733b18600b3fcab9b4a2e92ee50bbb8259c73e0dd4849db09fbb85" => :mavericks
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
