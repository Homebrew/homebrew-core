class Logtalk < Formula
  desc "Declarative object-oriented logic programming language"
  homepage "https://logtalk.org/"
  url "https://github.com/LogtalkDotOrg/logtalk3/archive/lgt3540stable.tar.gz"
  version "3.54.0"
  sha256 "6ccb72bd08a44ce28b75fb4a9f74fd34f7a1f4f57a0ba6158b876cf04c0cb34a"
  license "Apache-2.0"

  livecheck do
    url "https://logtalk.org/download.html"
    regex(/Latest stable version:.*?v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7ef3853bcba605c8346f9ca0a15017ba90b43dd8860b30a3c4b56b14dc75a0fe"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8ed43ba2100a7e2826861438bbd64c01619991064da088b3cc7f7445deb92806"
    sha256 cellar: :any_skip_relocation, monterey:       "adc974bac45da46c2442cd3d21d5e92e0b886587eb4f10642a4ec02bf1341d07"
    sha256 cellar: :any_skip_relocation, big_sur:        "87f434f5544796552d7e293ac2f1a0920b77686651acd4154e674530963d3ccf"
    sha256 cellar: :any_skip_relocation, catalina:       "19680fe4344eeffdbda192b38bc8d755451f63d3cf7d02f4d509df683e09ebd0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "98ee14cf7e82e12d14cc92c2e81504539e5052a8f44ebf38aaffd100e0255c1a"
  end

  depends_on "gnu-prolog"

  def install
    cd("scripts") { system "./install.sh", "-p", prefix }
  end
end
