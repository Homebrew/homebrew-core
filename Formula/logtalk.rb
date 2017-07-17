class Logtalk < Formula
  desc "Object-oriented logic programming language"
  homepage "http://logtalk.org"
  url "https://github.com/LogtalkDotOrg/logtalk3/archive/lgt3111stable.tar.gz"
  version "3.11.1"
  sha256 "ae3829fede61125ab5ea2aefc5fe03a0a46ceee1f3fca75fe8a484272630bb20"

  bottle do
    cellar :any_skip_relocation
    sha256 "a08761f5dea955b14a7d06fc3bdc6b56d6db16054a952db6e6ba0fe00aa57fdd" => :sierra
    sha256 "15cec06c8ec0f3977773ed29868cf013cd2a9a0b20413795feaf028757e24bc6" => :el_capitan
    sha256 "12c8d04105c6fc517b4bc60493961e566e490e82e6e08454be35389fc88f985c" => :yosemite
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
