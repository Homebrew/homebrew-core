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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fafb0f4ce065ee767944e0c861e0ee2a068d08758b0836fc59989375d01dfbfb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b834585f3fa36cb4c7a31cf345b098b116e71fbbab8335ee90729f70ef22180c"
    sha256 cellar: :any_skip_relocation, monterey:       "3cd3a58cd71399f571885dedd321771aad8678dac796214dc0c85e386f383f28"
    sha256 cellar: :any_skip_relocation, big_sur:        "975ecb49f737ff3305ef2c8d4087efe9826ddc6cd0454e6360e3bb8a5be3e745"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa3a521308076db67f50084b50f56214b90b437df3b34ab4004f7ab9b179199a"
  end

  depends_on "gnu-prolog"

  def install
    cd("scripts") { system "./install.sh", "-p", prefix }
  end
end
