class Logtalk < Formula
  desc "Declarative object-oriented logic programming language"
  homepage "https://logtalk.org/"
  url "https://github.com/LogtalkDotOrg/logtalk3/archive/refs/tags/lgt3730stable.tar.gz"
  version "3.73.0"
  sha256 "a1b3c886889d2cda2a0ad9fbc065352e22cdd3a959ff07bfe59cc09fa4271246"
  license "Apache-2.0"

  livecheck do
    url "https://logtalk.org/download.html"
    regex(/Latest stable version:.*?v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0ce12cea4d9d50e4f1f79815bf653d376c3dd8414d682a4705413529b9e54876"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4d114db8d37e7fbca895bae412d962bbc011d2cebf21a62c41f4e1f99fbb9e11"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f42ff62921b5bd7d13b2d1a1cb108df25a19d2ae33e50824b03aab2f40d9f089"
    sha256 cellar: :any_skip_relocation, sonoma:         "cd3b23ab7caa6e879244f8c4289be6f17e31d587031153b1beff8852d5d35322"
    sha256 cellar: :any_skip_relocation, ventura:        "49738ecd8fa62fb8fdf9706ea3427a9902e3ad08c1fe15ff174b9ac22677f123"
    sha256 cellar: :any_skip_relocation, monterey:       "a4a16a32e889d64c7c3efbd5461d9194b65aeae5016dd13bb34093a203706433"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ccf98336e77408763c011add6504782134009201fb8075442f29787d9ce5d691"
  end

  depends_on "gnu-prolog"

  def install
    cd("scripts") { system "./install.sh", "-p", prefix }
  end
end
