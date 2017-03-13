class Logtalk < Formula
  desc "Object-oriented logic programming language"
  homepage "http://logtalk.org"
  url "https://github.com/LogtalkDotOrg/logtalk3/archive/lgt3102stable.tar.gz"
  version "3.10.2"
  sha256 "6df4c121a1902a8bda662249924288b2561925b2acdbafa6c15ff4ec600feb61"

  bottle do
    cellar :any_skip_relocation
    sha256 "35413d4edd15a1ecf0b4fee600276cb0131edfe559821b80bb01f3c9dcff3459" => :sierra
    sha256 "68c96c3d02184b2d2037bc2197b67a229404a73358e7beba69a6dded930a2bd9" => :el_capitan
    sha256 "3fb51d3268f0972c0c95d1a6364091199ff3ef3595c4f1e62275be8d0c2ab54d" => :yosemite
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
