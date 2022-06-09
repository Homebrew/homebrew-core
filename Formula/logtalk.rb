class Logtalk < Formula
  desc "Declarative object-oriented logic programming language"
  homepage "https://logtalk.org/"
  url "https://github.com/LogtalkDotOrg/logtalk3/archive/lgt3560stable.tar.gz"
  version "3.56.0"
  sha256 "6ae4dd335fbccc8a86c20ff84d2156608ddf5e6d9c0582934bb606ec065fc56b"
  license "Apache-2.0"

  livecheck do
    url "https://logtalk.org/download.html"
    regex(/Latest stable version:.*?v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4d8b9ac9244a14d7a7955b461175a52a83d15c043833f2aa37a311f49daacb07"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "869610a6c2b875badb16d65bc9c85acd0a3cb7962820ebc33b67da2721317e0f"
    sha256 cellar: :any_skip_relocation, monterey:       "5301308e91d686803e901106d0f2f70af807d4c22ed83aa519d59b2e0fc3696b"
    sha256 cellar: :any_skip_relocation, big_sur:        "b5578dc9318e16cbbc550d60b0690a877651bf951853238e256edf7038658f73"
    sha256 cellar: :any_skip_relocation, catalina:       "c3ffb9d913ee6e65dad9bfdc85ce986698f8e592de96d3c9bedc73be003c3fd5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c2f4c980dae10849a037c9c84d571cb1c4c77b38aeb6f3009df6a8acef5b43db"
  end

  depends_on "gnu-prolog"

  def install
    cd("scripts") { system "./install.sh", "-p", prefix }
  end
end
