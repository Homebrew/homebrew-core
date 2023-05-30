class Logtalk < Formula
  desc "Declarative object-oriented logic programming language"
  homepage "https://logtalk.org/"
  url "https://github.com/LogtalkDotOrg/logtalk3/archive/lgt3660stable.tar.gz"
  version "3.66.0"
  sha256 "eaff4bbdfca4fe8b72a37e3379a9dc2b1bd7dc3b0d3c49c461760658c9e8922a"
  license "Apache-2.0"

  livecheck do
    url "https://logtalk.org/download.html"
    regex(/Latest stable version:.*?v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c036b69660f50444d6c6596d3ba43e5f5802740a02b236c86697423692bc32a4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b854696058e86ea38011e1fb21b8ee55781dc42f2cdc93f202c1b45f7c360ced"
    sha256 cellar: :any_skip_relocation, ventura:        "549c94eeb4a073c2edd8df8f4556bb071d9cf33cecec6d48768547cc532e3c8a"
    sha256 cellar: :any_skip_relocation, monterey:       "1d9c0f3f9e22e62c3c22fb7b7e298a87476853de54fc50b893d9019b72f55a1b"
    sha256 cellar: :any_skip_relocation, big_sur:        "07918f41e089585dcf628ebb73c06a307629b1720f523c172b0c753ae2e751a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb047544a3a50827fde5d11984ef29cbbec0f17fb8d8beacb7c5a62718e0100b"
  end

  depends_on "gnu-prolog"

  def install
    cd("scripts") { system "./install.sh", "-p", prefix }
  end
end
