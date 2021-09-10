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
    sha256 cellar: :any_skip_relocation, big_sur:      "896a7952e3a2386dfd72738d7e8db2ea7093cbc87ac95a0dd54f2f2ff8731654"
    sha256 cellar: :any_skip_relocation, catalina:     "565caebda460f0f8056f52225b9c64e34a916d02c7d33c61813d444be8486c4d"
    sha256 cellar: :any_skip_relocation, mojave:       "542112ff6c77d674249a8bbabfd5ffec99afb9276619c63b2bb3f00f04b2473f"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "9ef0dd35035c0f737d9fa28c6e5122beca2ffa436543688d36097f2d53fbf61e"
  end

  depends_on "gnu-prolog"

  def install
    cd("scripts") { system "./install.sh", "-p", prefix }
  end
end
