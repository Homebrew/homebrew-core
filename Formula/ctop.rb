class Ctop < Formula
  desc "Top-like interface for container metrics"
  homepage "https://bcicen.github.io/ctop/"
  url "https://github.com/bcicen/ctop.git",
      tag:      "v0.7.7",
      revision: "11a1cb10f416b4ca5e36c22c1acc2d11dbb24fb4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "518c92b0c3e0bc973d2e8b5c68f23d8e67167d71d3801a067c981254fcbb4dce"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "92a1aa5a1b27ddcc1499d196a3e1e87f67a0bbf89664308b8dc009030cf29d5a"
    sha256 cellar: :any_skip_relocation, monterey:       "27b7fcf883e5e9c5b2c3f3390f70358f0ce8cfe9a3e28a008c1b7bfeb1e13a81"
    sha256 cellar: :any_skip_relocation, big_sur:        "c654814649f0fdefb159bda66af0926fe0615c6ac185f6234a88642e7add2947"
    sha256 cellar: :any_skip_relocation, catalina:       "517e520dc241ade15a6f493b394efa25e212e779ec2d6f1bfd6b9ecd0f0a9627"
    sha256 cellar: :any_skip_relocation, mojave:         "8186e049abc8b0e5f1253c5f310ffb6884b7defad2a8ed6fe50dceee573e5bcd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a8f57a35650d0f5373da569e048732603b8325e345b74680a49f47bc55860ef8"
  end

  # Bump to 1.18 on the next release (0.7.7 or later).
  depends_on "go@1.17" => :build

  def install
    system "make", "build"
    bin.install "ctop"
  end

  test do
    system "#{bin}/ctop", "-v"
  end
end
