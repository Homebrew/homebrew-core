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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "00f2cbeddd3014385b0f20cde26dc68f4befcdc67cc9117f8c80981b5e2f20f7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8d2cc1fb951e29df6e84daa2de0fc159f6874762416e45c855eca17805983cb3"
    sha256 cellar: :any_skip_relocation, ventura:        "76a151c5c90678749b08d58f36d7da051d0110d33bac048d06e7aab52d41a743"
    sha256 cellar: :any_skip_relocation, monterey:       "a442be1e35c1782f5d214f7de6ca743578c198383fa969b5186eb5649263a266"
    sha256 cellar: :any_skip_relocation, big_sur:        "b9ecc913ec09cd36d5e8611a4d6fb01d68668d4856c436045fc8afe395a44d5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "42e0c797a6d0809605accd0193ee4de24a7ffb98f2c9874a3594e8c321cf2bed"
  end

  depends_on "gnu-prolog"

  def install
    cd("scripts") { system "./install.sh", "-p", prefix }
  end
end
