class Logtalk < Formula
  desc "Declarative object-oriented logic programming language"
  homepage "https://logtalk.org/"
  url "https://github.com/LogtalkDotOrg/logtalk3/archive/lgt3680stable.tar.gz"
  version "3.68.0"
  sha256 "5847625da312c3edcc2d8c9e51f6e9c0e3d0add277d916465e965a90b1a21318"
  license "Apache-2.0"

  livecheck do
    url "https://logtalk.org/download.html"
    regex(/Latest stable version:.*?v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e1872e76c23ab8734d4aa2040da84ebf5343e916057e16bc5d46c25317e836fa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8a405c2fd9ed9baf83b04a27e7d1767d3f4aec6aabed3833808e3a0fed96aa5a"
    sha256 cellar: :any_skip_relocation, ventura:        "0b27a05d5278831f270645c1002ac1d93d484deeace2c533d6a5c6cd1b45d1f8"
    sha256 cellar: :any_skip_relocation, monterey:       "c45f04ee4964eb1e2ed3ba891c3d26e6d6e0a0c049f401ac07a7ac2ae6c3a849"
    sha256 cellar: :any_skip_relocation, big_sur:        "4cfdd7e3a6cb9f2f25be302843c207a71d5d0fcc0418628b7ff3580673427dc9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "08eb2abce3fb5bc037d338857f251abed1a2750bef144ff8f94dbccdfaf6c36f"
  end

  depends_on "gnu-prolog"

  def install
    cd("scripts") { system "./install.sh", "-p", prefix }
  end
end
