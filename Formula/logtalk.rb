class Logtalk < Formula
  desc "Declarative object-oriented logic programming language"
  homepage "https://logtalk.org/"
  url "https://github.com/LogtalkDotOrg/logtalk3/archive/lgt3500stable.tar.gz"
  version "3.50.0"
  sha256 "41acb7b8c2ceb6290b02ed1e9ae7cc03e3fef989e3f35a843541341e6e589e53"
  license "Apache-2.0"

  livecheck do
    url "https://logtalk.org/download.html"
    regex(/Latest stable version:.*?v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:      "8a31defbd0313db67bba438a7f8aa24d49161ed85ad5c74776e404bbcd841aab"
    sha256 cellar: :any_skip_relocation, catalina:     "1170859ece42694cf9ae64b33c52120c41be01b523af90a02e7929bb1278a08e"
    sha256 cellar: :any_skip_relocation, mojave:       "c7e94bba3b8987abcf1d29ee4490e6319398d0dc75828401a918ec8101f44ff8"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "2f1f1fabeef4d17bee60fd49ea5a758f6e6bd9af7763e39b5610a6fe289d7c42"
  end

  depends_on "gnu-prolog"

  def install
    cd("scripts") { system "./install.sh", "-p", prefix }
  end
end
