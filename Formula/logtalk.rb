class Logtalk < Formula
  desc "Declarative object-oriented logic programming language"
  homepage "https://logtalk.org/"
  url "https://github.com/LogtalkDotOrg/logtalk3/archive/lgt3530stable.tar.gz"
  version "3.53.0"
  sha256 "0e33cedee871951bf8e2d3e163f16b1904cbb90dd17bcb9052694053e6977bb5"
  license "Apache-2.0"

  livecheck do
    url "https://logtalk.org/download.html"
    regex(/Latest stable version:.*?v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "53ffd930b6b4b65ee7bdff4da868a0cbc1be1442a855e317a9decf039f9e4c0e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8c10cad4a854d3a353cbb5b0662cb2f0b1dfdc7a4b8c4bf329bf9ddbf74d4907"
    sha256 cellar: :any_skip_relocation, monterey:       "539edce08bf909cb81d69b779ef8bd81ba5103c66202cb26fed1afc739e78195"
    sha256 cellar: :any_skip_relocation, big_sur:        "62d8cef9163a44198914c4bfaf36bf2a810ae0dc1cd36d8a3b4fa6fdff0fe11a"
    sha256 cellar: :any_skip_relocation, catalina:       "a7efc68669649b88161285cb8e3ad2e7ae335a23f8f3eea78f7f4245acf47271"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c6b84e1bb87adacc30716c376cb9612ecd65af9937f4e2cd73840608bbb2063"
  end

  depends_on "gnu-prolog"

  def install
    cd("scripts") { system "./install.sh", "-p", prefix }
  end
end
