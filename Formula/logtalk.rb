class Logtalk < Formula
  desc "Declarative object-oriented logic programming language"
  homepage "https://logtalk.org/"
  url "https://github.com/LogtalkDotOrg/logtalk3/archive/lgt3580stable.tar.gz"
  version "3.58.0"
  sha256 "ac2c9dcbacdcd24ffe411cfa2dbbbab10e6b2a6075dc49f6ed19c534dd79c38e"
  license "Apache-2.0"

  livecheck do
    url "https://logtalk.org/download.html"
    regex(/Latest stable version:.*?v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6eab53054e479fa225f8da26e87ab551580ad09c42fcd78806b46b326b8813cf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8fe4b37a646df50d77621ad3d0d1c033a22b65f168351f89e807bc91bb0ac2bf"
    sha256 cellar: :any_skip_relocation, monterey:       "be5f7ee77860276a18b145b22167a65d39d87035b4394a45f0f6336cb00478e3"
    sha256 cellar: :any_skip_relocation, big_sur:        "fce0d70a6745f18602a61d7cda2e37ebf80e00d06371a1c19c6e852bc6cbbb15"
    sha256 cellar: :any_skip_relocation, catalina:       "0b727fb680031ad256d1b927dcf45bd99d987c5d90e5a87fbc1e0ecd733f6439"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1eea06bd682fb89bd2fd7e138d60389208a448b39774fbc5fbb5668902d59594"
  end

  depends_on "gnu-prolog"

  def install
    cd("scripts") { system "./install.sh", "-p", prefix }
  end
end
