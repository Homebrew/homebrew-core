class Logtalk < Formula
  desc "Declarative object-oriented logic programming language"
  homepage "https://logtalk.org/"
  url "https://github.com/LogtalkDotOrg/logtalk3/archive/lgt3590stable.tar.gz"
  version "3.59.0"
  sha256 "89aac05347d456712a670c5a8dacb4fbb51ec0ef16c5707c7384480aae01c721"
  license "Apache-2.0"

  livecheck do
    url "https://logtalk.org/download.html"
    regex(/Latest stable version:.*?v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f0a57b53b8f9f9c1433e664c37f5fcbc9176034dd1e4652fd6484de71a306836"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f0a57b53b8f9f9c1433e664c37f5fcbc9176034dd1e4652fd6484de71a306836"
    sha256 cellar: :any_skip_relocation, monterey:       "06c5358d7cf2acf66f08041c565fee3c3d069b1e4d709739dab2f002540da264"
    sha256 cellar: :any_skip_relocation, big_sur:        "81f4160c3f8bd35026cb2f5ad5d4e138df6505d8eb9e083ca32e1cf945b013ff"
    sha256 cellar: :any_skip_relocation, catalina:       "011d55bf25c37aff53324995e55735f7dbe8086458a8249cd50c40cca7a1c856"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c44965161d6dcf463e0c52fc2f20f79b210f8e235eae3fee452574b81bcd460c"
  end

  depends_on "gnu-prolog"

  def install
    cd("scripts") { system "./install.sh", "-p", prefix }
  end
end
