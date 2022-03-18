class N < Formula
  desc "Node version management"
  homepage "https://github.com/tj/n"
  url "https://github.com/tj/n/archive/v8.1.0.tar.gz"
  sha256 "adf97836bfd66e79776b1330e84b9f089f73e9e89d3a6fd6e385a95d3eab2af5"
  license "MIT"
  head "https://github.com/tj/n.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "24b9b9ec8d00695e067056f4c81bd5c81e9190fa9def9f6495979a476c469d3c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "24b9b9ec8d00695e067056f4c81bd5c81e9190fa9def9f6495979a476c469d3c"
    sha256 cellar: :any_skip_relocation, monterey:       "9bfb4d89c9452cc533e1a0031eb9177397fec72e70b1c01965558e7e33fe9c45"
    sha256 cellar: :any_skip_relocation, big_sur:        "9bfb4d89c9452cc533e1a0031eb9177397fec72e70b1c01965558e7e33fe9c45"
    sha256 cellar: :any_skip_relocation, catalina:       "9bfb4d89c9452cc533e1a0031eb9177397fec72e70b1c01965558e7e33fe9c45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "24b9b9ec8d00695e067056f4c81bd5c81e9190fa9def9f6495979a476c469d3c"
  end

  def install
    bin.mkdir
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system bin/"n", "ls"
  end
end
