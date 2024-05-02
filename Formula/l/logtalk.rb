class Logtalk < Formula
  desc "Declarative object-oriented logic programming language"
  homepage "https://logtalk.org/"
  url "https://github.com/LogtalkDotOrg/logtalk3/archive/refs/tags/lgt3770stable.tar.gz"
  version "3.77.0"
  sha256 "ec6db5b01d90001eedbe654688b483e778b9157d96019a412ce4a017f76b4dc8"
  license "Apache-2.0"

  livecheck do
    url "https://logtalk.org/download.html"
    regex(/Latest stable version:.*?v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bb570074b606d26d70942ecf6191fa8504cc21b9015648156fc12d1be29eba5a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e5bd980cc174de4433988231d4bc29782f99a622222e9857f49df42edda226f3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5a95fc207d1eda7cc4d48c3f9c681da929c123595cd718c6cb373e2419052069"
    sha256 cellar: :any_skip_relocation, sonoma:         "4ba1b15caf03fb2e0c17eb51b3d830dd2429c519756bb108bfe5a48e2ed47d93"
    sha256 cellar: :any_skip_relocation, ventura:        "dad69ebeb9bec27ed5bbb1295e001b70ea1af05718ce474a6638cd41e5f0cd84"
    sha256 cellar: :any_skip_relocation, monterey:       "641bd670335ef40447e338cdf9ebb16bde75be59f7b0cac23e8106c884c2cc15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7850fa92228a63385593d5e37eb421bf915e8aab1b926c8861ceab3b9e851ee6"
  end

  depends_on "gnu-prolog"

  def install
    cd("scripts") { system "./install.sh", "-p", prefix }
  end
end
