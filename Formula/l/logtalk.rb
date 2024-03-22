class Logtalk < Formula
  desc "Declarative object-oriented logic programming language"
  homepage "https://logtalk.org/"
  url "https://github.com/LogtalkDotOrg/logtalk3/archive/refs/tags/lgt3760stable.tar.gz"
  version "3.76.0"
  sha256 "8fe4083df70b6b4ee4b8e5565355c5a44dd0e6fb50f016d4502ed5d3ef3b460b"
  license "Apache-2.0"

  livecheck do
    url "https://logtalk.org/download.html"
    regex(/Latest stable version:.*?v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0fcbe9f61e814f50a90ccf475e689481828cd7b5fecb652579a81aebc9f95292"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5a7853a8157baa7082792b4b667f1ec7864d7f28514d0594b1dfe51974879c13"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2a5e4b49d1d3ac7b71e030ff28ec39de572f5ad6a6bd86618ff71e62e3e1a130"
    sha256 cellar: :any_skip_relocation, sonoma:         "cb2ebc84b2015344290466be07ca0e91a26f78ea45d43da4b17d1d309520efec"
    sha256 cellar: :any_skip_relocation, ventura:        "2a4c9098b0b92a789b65964be27cf786829ada3b8ab90322dba58f64f3fcd096"
    sha256 cellar: :any_skip_relocation, monterey:       "7db2f664e9f92884dee40d9f6ff047647973217229b9c6373bed0306cdaca540"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f59abdfeaf2e88b86a819863fb983953a14ab8353577f3a9c98d1de00f76fed4"
  end

  depends_on "gnu-prolog"

  def install
    cd("scripts") { system "./install.sh", "-p", prefix }
  end
end
