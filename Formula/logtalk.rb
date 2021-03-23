class Logtalk < Formula
  desc "Declarative object-oriented logic programming language"
  homepage "https://logtalk.org/"
  url "https://github.com/LogtalkDotOrg/logtalk3/archive/lgt3450stable.tar.gz"
  version "3.45.0"
  sha256 "95ffa164be2688fce0a7dab2be170ef4bbe8d64617351fce1fcdccfa9bb62a5d"
  license "Apache-2.0"

  livecheck do
    url "https://logtalk.org/download.html"
    regex(/Latest stable version:.*?v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "de48173164253eefda8b44b924baecbe5e4d5b51e4d2955be6d2d26b5e58c420"
    sha256 cellar: :any_skip_relocation, catalina: "7b641c19f7f9178b4343984b300061e457a2ce691a39eda545c4213f85efe993"
    sha256 cellar: :any_skip_relocation, mojave:   "dd5e07179762b093c6279d04f51dbddd63d850df3c40dda7647f365ac0aa0e9c"
  end

  depends_on "gnu-prolog"

  def install
    cd("scripts") { system "./install.sh", "-p", prefix }
  end
end
