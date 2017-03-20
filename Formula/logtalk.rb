class Logtalk < Formula
  desc "Object-oriented logic programming language"
  homepage "http://logtalk.org"
  url "https://github.com/LogtalkDotOrg/logtalk3/archive/lgt3103stable.tar.gz"
  version "3.10.3"
  sha256 "fad5809aabbaba8d4df1895c19dba64d14b1b08d64375da08e12d3673f294a29"

  bottle do
    cellar :any_skip_relocation
    sha256 "2fcba4cbc830f048a16c9cee829b4f9f026723b54473a316dc32afaef20bf712" => :sierra
    sha256 "5c2a5f6cc605fd884b6a5c68b8dd8cf00522897ffeebb1c24aa7c1cda9383a7b" => :el_capitan
    sha256 "1f73f94e4e3babb461773f55b4e9f3269246cb902fb4b53370203073fbb30aa9" => :yosemite
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
