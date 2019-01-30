class Logtalk < Formula
  desc "Object-oriented logic programming language"
  homepage "https://logtalk.org/"
  url "https://github.com/LogtalkDotOrg/logtalk3/archive/lgt3230stable.tar.gz"
  version "3.23.0"
  sha256 "0ea042bcc323d9ef688522698216db4bf3814c435689dfc8b3b00220184504a4"

  bottle do
    cellar :any_skip_relocation
    sha256 "4aaf180fd7239bd983ebdcfebf7e9db2871ae9524aa12a00041abfe9a4259fed" => :mojave
    sha256 "8b1ecd36b525c6442c995829c7e41b9eb6484f23749198b2ebfdb9afa0f18305" => :high_sierra
    sha256 "fed47833e640ee882a8fd6a2e59eff30842b27a9034a81331c792c7e3dd31469" => :sierra
  end

  depends_on "gnu-prolog"

  def install
    cd("scripts") { system "./install.sh", "-p", prefix }
  end
end
