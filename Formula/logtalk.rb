class Logtalk < Formula
  desc "Object-oriented logic programming language"
  homepage "https://logtalk.org/"
  url "https://github.com/LogtalkDotOrg/logtalk3/archive/lgt3310stable.tar.gz"
  version "3.31.0"
  sha256 "59c164305959de4d11f96cb0571bf46bca592ff77c4af8591b26b9b57f394bdd"

  bottle do
    cellar :any_skip_relocation
    sha256 "449e97748d8f9b4bedfbe6270f8d455c13815a8b2a561a68dbffe2bd74d3cacf" => :catalina
    sha256 "b006b20c208943694cb6ba6094f1f08dee424e8020d4ef9601ff7062318041ef" => :mojave
    sha256 "7e9f3f8ca401a68cd3ef607037d7244005793f9ec0a17c6d33de4f65203437b8" => :high_sierra
  end

  depends_on "gnu-prolog"

  def install
    cd("scripts") { system "./install.sh", "-p", prefix }
  end
end
