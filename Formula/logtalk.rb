class Logtalk < Formula
  desc "Object-oriented logic programming language"
  homepage "http://logtalk.org"
  url "https://github.com/LogtalkDotOrg/logtalk3/archive/lgt3091stable.tar.gz"
  version "3.09.1"
  sha256 "0f924addae488bb1cd68d9aeec480905736abfc15339d896c268b708408c0518"

  bottle do
    cellar :any_skip_relocation
    sha256 "d23f9ec0d6102d83d99e0ec80fbb31c25a0be889552b7b282ab2617672ec2e9f" => :sierra
    sha256 "00bccf06127c735c58f77f254831a688622da45d41519c8cd2d4dfd5f93a9e49" => :el_capitan
    sha256 "baa46e95cd5c6eb91a89ec8d8a93200e9840c7d05536ad448d23cd9c7d6ff656" => :yosemite
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
