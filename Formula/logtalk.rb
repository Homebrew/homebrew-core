class Logtalk < Formula
  desc "Declarative object-oriented logic programming language"
  homepage "https://logtalk.org/"
  url "https://github.com/LogtalkDotOrg/logtalk3/archive/lgt3480stable.tar.gz"
  version "3.48.0"
  sha256 "d7e727b33692947f7cba8e51e5a157bd46b852367c6b7229eba1e35ad12ee005"
  license "Apache-2.0"

  livecheck do
    url "https://logtalk.org/download.html"
    regex(/Latest stable version:.*?v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "48b5790a26bdee8b3d4f271b4c02308958a75f65db13002b36252d16f2094aaf"
    sha256 cellar: :any_skip_relocation, catalina: "fd1de67e21bae7559a5a1dba61363c72df72eb264b6153275a2bc89e16f381a2"
    sha256 cellar: :any_skip_relocation, mojave:   "56f471841043c825f486a6394254c946a4b4e9a589d0212869f3b276d7bd3d5b"
  end

  depends_on "gnu-prolog"

  def install
    cd("scripts") { system "./install.sh", "-p", prefix }
  end
end
