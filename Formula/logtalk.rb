class Logtalk < Formula
  desc "Object-oriented logic programming language"
  homepage "https://logtalk.org/"
  url "https://github.com/LogtalkDotOrg/logtalk3/archive/lgt3340stable.tar.gz"
  version "3.34.0"
  sha256 "a56c8f2a35bea4768dfde1237bae1183edb24d688fd5d25bfc997eb5868b93bd"

  bottle do
    cellar :any_skip_relocation
    sha256 "09359b984e1d25257587676f289dbda1a79fc58f9ede409becc01d7bc90dd380" => :catalina
    sha256 "75dfbc2447139b6a4767aa6054383dadcfe32a4bc74214cb769b1c3204f30ff4" => :mojave
    sha256 "e13a04848e8fea6328e869b5475567dd10400e16738c17b8c45fa9871382cd07" => :high_sierra
  end

  depends_on "gnu-prolog"

  def install
    cd("scripts") { system "./install.sh", "-p", prefix }
  end
end
