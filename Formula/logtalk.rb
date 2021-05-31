class Logtalk < Formula
  desc "Declarative object-oriented logic programming language"
  homepage "https://logtalk.org/"
  url "https://github.com/LogtalkDotOrg/logtalk3/archive/lgt3470stable.tar.gz"
  version "3.47.0"
  sha256 "d98be342be120e6c6078571842551bf3db580bad37400dc64d8d530a1b2287f9"
  license "Apache-2.0"

  livecheck do
    url "https://logtalk.org/download.html"
    regex(/Latest stable version:.*?v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "c1410c2657755a09dac0cee084bb0939d9a98406a11d0d6a4751c16ec97de885"
    sha256 cellar: :any_skip_relocation, catalina: "7897b2f6b45f04273d649462dfa1344a0d33c5b83dcd847d2f7d906564f6885a"
    sha256 cellar: :any_skip_relocation, mojave:   "e6e05afc2964203dc1209dda3386889e5db25201548dd711cfe1ceb313eaffb1"
  end

  depends_on "gnu-prolog"

  def install
    cd("scripts") { system "./install.sh", "-p", prefix }
  end
end
