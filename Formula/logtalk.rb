class Logtalk < Formula
  desc "Declarative object-oriented logic programming language"
  homepage "https://logtalk.org/"
  url "https://github.com/LogtalkDotOrg/logtalk3/archive/lgt3620stable.tar.gz"
  version "3.62.0"
  sha256 "f60d5a5dced8e0b0256854870ddbb0a3d3b08f001c5e62d8af56ada2668ce563"
  license "Apache-2.0"

  livecheck do
    url "https://logtalk.org/download.html"
    regex(/Latest stable version:.*?v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b3baaaae0206922b73983312e0a397b6a88aa8611eb711ff96f5845a11fcc32b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f2c2089beac032ba2363d4dde788763cc9897d2dca797e034117b3741cffd79d"
    sha256 cellar: :any_skip_relocation, monterey:       "e858853bed353ee6d38d88ead6a656934aeb07d2b4722e5dffccd7283c614bf0"
    sha256 cellar: :any_skip_relocation, big_sur:        "01382a82b2c73b4a65d8aacfeb733f612bcd036bdd4fc44e75b270e42ca78405"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e1d44a7c436f6f57861b1e6d07ecb393b52d007580b2b4714dd91554f122026e"
  end

  depends_on "gnu-prolog"

  def install
    cd("scripts") { system "./install.sh", "-p", prefix }
  end
end
