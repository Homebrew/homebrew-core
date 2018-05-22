class Logtalk < Formula
  desc "Object-oriented logic programming language"
  homepage "https://logtalk.org/"
  url "https://github.com/LogtalkDotOrg/logtalk3/archive/lgt3170stable.tar.gz"
  version "3.17.0"
  sha256 "012463d97d15cad542a8c701b5e897b6562407c8ab7ab40021afac309db13d67"

  bottle do
    cellar :any_skip_relocation
    sha256 "274bc573c66a48b563efd22562afbf120bb277d10259f766cafb9e837b7fb61c" => :high_sierra
    sha256 "85406c3d611b5f3000e110da0b9f76333b5c867ec2a886911d57c654435f0039" => :sierra
    sha256 "c8117b48303c897ccf3b2f11d1e8bacbe929abe9c0d7bca48dbe1a6b2ac9d244" => :el_capitan
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
