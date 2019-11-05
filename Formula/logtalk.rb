class Logtalk < Formula
  desc "Object-oriented logic programming language"
  homepage "https://logtalk.org/"
  url "https://github.com/LogtalkDotOrg/logtalk3/archive/lgt3320stable.tar.gz"
  version "3.32.0"
  sha256 "c9cbbde44e250f31d81b2fb7e160da4f45c8d232b328f3729b9c54d76a693d2b"

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
