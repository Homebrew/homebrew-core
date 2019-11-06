class Logtalk < Formula
  desc "Object-oriented logic programming language"
  homepage "https://logtalk.org/"
  url "https://github.com/LogtalkDotOrg/logtalk3/archive/lgt3320stable.tar.gz"
  version "3.32.0"
  sha256 "c9cbbde44e250f31d81b2fb7e160da4f45c8d232b328f3729b9c54d76a693d2b"

  bottle do
    cellar :any_skip_relocation
    sha256 "d675f7b89f03ac2cac91f607a07e3f9c5e858d91eb100cd617be6f696f7d8e38" => :catalina
    sha256 "b153a8948db77431ccde41cb6f9171f2ec526902de80b34da1ed8706d8398280" => :mojave
    sha256 "fd7bcba054328baa5d52f3d3910dabcda07587b5c0ef1bb8d30eefc18bffe6f9" => :high_sierra
  end

  depends_on "gnu-prolog"

  def install
    cd("scripts") { system "./install.sh", "-p", prefix }
  end
end
