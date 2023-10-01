class Logtalk < Formula
  desc "Declarative object-oriented logic programming language"
  homepage "https://logtalk.org/"
  url "https://github.com/LogtalkDotOrg/logtalk3/archive/lgt3700stable.tar.gz"
  version "3.70.0"
  sha256 "055e61b2b37552117f4f76a96f480b68955dcb7339ae8e8f2ff32de432c402f7"
  license "Apache-2.0"

  livecheck do
    url "https://logtalk.org/download.html"
    regex(/Latest stable version:.*?v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f70347e5d00da82be8267d1d500dc5308d1c7ec7276454290e4ff3ba089f758c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0fc3279a58a9a93dbab3121337e5286212a47528e261c41283c9438286e3ec00"
    sha256 cellar: :any_skip_relocation, ventura:        "729af1c8557434c546d3796dfce65e137835d89f59b6e06ca8abf9a7c4467720"
    sha256 cellar: :any_skip_relocation, monterey:       "d1cbdee1aa8225db72267e7c68c8fe5ee76083173c6a85c1dc740534031d276f"
    sha256 cellar: :any_skip_relocation, big_sur:        "4fee0ee61ce75c6fb5c40253f7196ac6c5c13ea9d5c2c397b7cd808e5957f2f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fca4c9bfaa9260084fee1f54d9032af9e6a254fe373251c73edc6408ee2b2996"
  end

  depends_on "gnu-prolog"

  def install
    cd("scripts") { system "./install.sh", "-p", prefix }
  end
end
