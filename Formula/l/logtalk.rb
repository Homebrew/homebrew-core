class Logtalk < Formula
  desc "Declarative object-oriented logic programming language"
  homepage "https://logtalk.org/"
  url "https://github.com/LogtalkDotOrg/logtalk3/archive/lgt3690stable.tar.gz"
  version "3.69.0"
  sha256 "4fbd017d6b6e5b4008a22c8aa5f89aa66c7d4565951757582b8847725e517a1f"
  license "Apache-2.0"

  livecheck do
    url "https://logtalk.org/download.html"
    regex(/Latest stable version:.*?v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7b9cd2cfaf2a01dcf8f981818203818ecec17c74f57ed738b2bf5bfa504db2cf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d97338a55e7d7d5e671d1295c1450e31276e1126c47622498c805aa1c29273ee"
    sha256 cellar: :any_skip_relocation, ventura:        "59cfff7eabcab0e441e58d37a2abd3fef40c86249dab098c6ba26ebc5fd42cc5"
    sha256 cellar: :any_skip_relocation, monterey:       "6339697cc02249983787481303e944b8c69b562a38e4d9093d885aaf8c6dd3b6"
    sha256 cellar: :any_skip_relocation, big_sur:        "0a8ecae24ed9805676445ba67881f9230837421df98654f675f702ccdc04d65a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d9f670ae413cb30aa6d07549eee721a359d378e9f7c876585546770f0ba1c87d"
  end

  depends_on "gnu-prolog"

  def install
    cd("scripts") { system "./install.sh", "-p", prefix }
  end
end
