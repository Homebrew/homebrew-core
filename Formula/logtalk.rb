class Logtalk < Formula
  desc "Declarative object-oriented logic programming language"
  homepage "https://logtalk.org/"
  url "https://github.com/LogtalkDotOrg/logtalk3/archive/lgt3390stable.tar.gz"
  version "3.39.0"
  sha256 "766890e64e43967bf8c7d8e8bb69369d2992a87d9adee2df90cc715542103d53"

  bottle do
    cellar :any_skip_relocation
    sha256 "73649c788fd6ebc4f6ab1456734c431c62475167acb8156b9dba5839ce29951a" => :catalina
    sha256 "30be3d195521c8c7da84fa717f932a660220805e4cdb2f9e526b7ceb4669b47d" => :mojave
    sha256 "c333d71a7427c66e92c296cbec0abe67ad481a5a940065207f60ef9274577d99" => :high_sierra
  end

  depends_on "gnu-prolog"

  def install
    cd("scripts") { system "./install.sh", "-p", prefix }
  end
end
