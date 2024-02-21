class Httpdiff < Formula
  desc "Compare two HTTP(S) responses"
  homepage "https://github.com/jgrahamc/httpdiff"
  url "https://github.com/jgrahamc/httpdiff/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "b2d3ed4c8a31c0b060c61bd504cff3b67cd23f0da8bde00acd1bfba018830f7f"
  license "GPL-2.0"
  head "https://github.com/jgrahamc/httpdiff.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fb3ba79a205bd981619555ecf41ca6e137e909e81584fab9f99ee866c2894f76"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "92a83ed3c1661dcfda3e29bf72ea203caed009916edf179e21e1f56fded10c67"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "976753c4e064c4dbd0994aba563bac6d0b77cd05baba4b265c13e49811e630c6"
    sha256 cellar: :any_skip_relocation, sonoma:         "ad69abab3d99d25736c9017d6150b152d936d0be30540d080e42201cf2a1e852"
    sha256 cellar: :any_skip_relocation, ventura:        "e2cf711b03af114403ff20ac0cd7565043273e5c7d2b7f34148dfd1f51008a13"
    sha256 cellar: :any_skip_relocation, monterey:       "bfd140f70cd77286862c07f915f2501b92674a8e0285a51c72a744104bc50b39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e246edcfa7a513659fefbbe3facb39d1103f8678768e92b0fc370dfcc1db74b1"
  end

  # https://github.com/jgrahamc/httpdiff/issues/21
  deprecate! date: "2024-02-20", because: :unmaintained

  depends_on "go" => :build

  def install
    ENV["GO111MODULE"] = "auto"
    system "go", "build", "-o", bin/"httpdiff"
  end

  test do
    system bin/"httpdiff", "https://brew.sh/", "https://brew.sh/"
  end
end
