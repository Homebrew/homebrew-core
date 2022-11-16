class Logtalk < Formula
  desc "Declarative object-oriented logic programming language"
  homepage "https://logtalk.org/"
  url "https://github.com/LogtalkDotOrg/logtalk3/archive/lgt3600stable.tar.gz"
  version "3.60.0"
  sha256 "254997f38c67756b1087f3caa958403a7a30ae2b241b9fada4ad9e07fae4d120"
  license "Apache-2.0"

  livecheck do
    url "https://logtalk.org/download.html"
    regex(/Latest stable version:.*?v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "10748c1aa30753d42918f24275f79af5aab452a275002e2beb6d92c7defd8b26"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4a7770c7d1c565e180ac85005e0b4b270a8416c2d59bf153806a9c961cc57b5a"
    sha256 cellar: :any_skip_relocation, monterey:       "5f42a36626ae64931f4c1583b33f01db615f9b03fa8e9e48cadfcca06525f43b"
    sha256 cellar: :any_skip_relocation, big_sur:        "f1024a6bb2c90e640243f2253ccc6b7e2b0e8bdea30ea4c844c993744bcd3d8b"
    sha256 cellar: :any_skip_relocation, catalina:       "5ba79224bbd85842875cec82f074725769d43003afa4c23ab843776689fb32f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5128e04513564f3c32acc6412b9a1fe9eb6c66f770ef675280387e8a55d01883"
  end

  depends_on "gnu-prolog"

  def install
    cd("scripts") { system "./install.sh", "-p", prefix }
  end
end
