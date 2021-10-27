class Logtalk < Formula
  desc "Declarative object-oriented logic programming language"
  homepage "https://logtalk.org/"
  url "https://github.com/LogtalkDotOrg/logtalk3/archive/lgt3510stable.tar.gz"
  version "3.51.0"
  sha256 "6ac6aed12c6d26e8a6b06f995a95ad24a9f2d29db021c050812db2da4e61196e"
  license "Apache-2.0"

  livecheck do
    url "https://logtalk.org/download.html"
    regex(/Latest stable version:.*?v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:      "a90438cb7197c9b3602a9b4ced05fcf72a88769405e508d9d506b2cbad38e8dd"
    sha256 cellar: :any_skip_relocation, catalina:     "e64c70973ad23731d66c98d936e02baa0ba4d2e96799db082185cdb3025af053"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "c2bc934c985bf58834c22e5ee95279522eebe19a8f1256bf822df98dadc4276b"
  end

  depends_on "gnu-prolog"

  def install
    cd("scripts") { system "./install.sh", "-p", prefix }
  end
end
