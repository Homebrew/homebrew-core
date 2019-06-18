class Logtalk < Formula
  desc "Object-oriented logic programming language"
  homepage "https://logtalk.org/"
  url "https://github.com/LogtalkDotOrg/logtalk3/archive/lgt3270stable.tar.gz"
  version "3.27.0"
  sha256 "ddfbd126bd6663462d72df113bf2a77ccc197a03a4133d465b0d07afa8d62363"

  bottle do
    cellar :any_skip_relocation
    sha256 "2faf1ca1f9fe57601031c0608196961c85e2fddbbe7158749cf8192afea09a92" => :mojave
    sha256 "61d14b01abacb9f7dec610f7c08721b63cda9738a8b7a7cfe6f6c27908618b4c" => :high_sierra
    sha256 "41dad06e989e133d836bbe0fe2815a72a65cb1b07df76fde221bc6ef8440f9ad" => :sierra
  end

  depends_on "gnu-prolog"

  def install
    cd("scripts") { system "./install.sh", "-p", prefix }
  end
end
