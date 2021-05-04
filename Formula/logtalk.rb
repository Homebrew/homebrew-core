class Logtalk < Formula
  desc "Declarative object-oriented logic programming language"
  homepage "https://logtalk.org/"
  url "https://github.com/LogtalkDotOrg/logtalk3/archive/lgt3460stable.tar.gz"
  version "3.46.0"
  sha256 "6998fb8b5e20435bcbc52508a8f7c59483ca5485974ef40b0bfb31eb6f46654e"
  license "Apache-2.0"

  livecheck do
    url "https://logtalk.org/download.html"
    regex(/Latest stable version:.*?v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "0a3d73cdaedce85da2857ac3a43a8aa058a27a5fc1bdf4c37a6de51d5598dd19"
    sha256 cellar: :any_skip_relocation, catalina: "900971a976dc25289dd97871c9b23073522156267adc17be9181a602644358ad"
    sha256 cellar: :any_skip_relocation, mojave:   "0a31e04f9d5f1ad4d3a5d3e59b8ee8fcd3bc68ffcebe7fcd6b3933bdc09ed80c"
  end

  depends_on "gnu-prolog"

  def install
    cd("scripts") { system "./install.sh", "-p", prefix }
  end
end
