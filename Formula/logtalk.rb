class Logtalk < Formula
  desc "Object-oriented logic programming language"
  homepage "https://logtalk.org/"
  url "https://github.com/LogtalkDotOrg/logtalk3/archive/lgt3350stable.tar.gz"
  version "3.35.0"
  sha256 "144e4fcdf22de31365150679777bc20a545b09e22e1c4f826f38644af2488eb1"

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
