class Logtalk < Formula
  desc "Declarative object-oriented logic programming language"
  homepage "https://logtalk.org/"
  url "https://github.com/LogtalkDotOrg/logtalk3/archive/lgt3630stable.tar.gz"
  version "3.63.0"
  sha256 "58dcfc38c82295ebf8d88d6a8bb19d5e822f1e93aa95f62f2850723ee1e4734a"
  license "Apache-2.0"

  livecheck do
    url "https://logtalk.org/download.html"
    regex(/Latest stable version:.*?v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "210a61f8d1dbd4274734a2d45c5b3e745436056fc1bd1934cdf37492901971d9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "72a49e827d0e7affa66dfa0a0391da6afc87437751d0d352d0ed4f8b39f5fcd2"
    sha256 cellar: :any_skip_relocation, monterey:       "9c4f8c03513108aeb5648cf64f972228cd8c4c3fc1235c4b68e68e2fa1202168"
    sha256 cellar: :any_skip_relocation, big_sur:        "64bd7d4feb53c98991a7c024ae4436b9fc14fdd8863b6ecdff3cab0e80b4140e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a3f8945de221d0ae189d767f85f35b5b81076b0f18a5f5229ccd1ac2bca9aec0"
  end

  depends_on "gnu-prolog"

  def install
    cd("scripts") { system "./install.sh", "-p", prefix }
  end
end
