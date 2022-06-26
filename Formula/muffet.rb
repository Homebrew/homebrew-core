class Muffet < Formula
  desc "Fast website link checker in Go"
  homepage "https://github.com/raviqqe/muffet"
  url "https://github.com/raviqqe/muffet/archive/v2.5.0.tar.gz"
  sha256 "53a0f673181be525ad0c937c0c93d57343dc303886a9b60332730ea17258b52f"
  license "MIT"
  head "https://github.com/raviqqe/muffet.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d2f630377635cf1092a559798f736bf2fc81b1ebcabfc8ce0aab4690fd839702"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5ba19d552ad34a23f2c8bf2285e1d093e11e29674c95e34d84a0d6bdc6647f01"
    sha256 cellar: :any_skip_relocation, monterey:       "d7fd72d66777a184411fcd29e5769422fcca8f3375378554187b2a82549fe8a9"
    sha256 cellar: :any_skip_relocation, big_sur:        "c2cd85c18be9672c46d6f47327fa2e4058f00fd4a5886ac3e7e2b9bddfdb0c90"
    sha256 cellar: :any_skip_relocation, catalina:       "be913f18a51f0b408b2178cc57d7b42d1faf00557bba8c3874f14dd3aae20f25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee45c667592566fde507be5efb12f59481de18bb900d936f3c543bb773b804bd"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match(/failed to fetch root page: lookup does\.not\.exist.*: no such host/,
                 shell_output("#{bin}/muffet https://does.not.exist 2>&1", 1))

    assert_match "https://httpbin.org/",
                 shell_output("#{bin}/muffet https://httpbin.org 2>&1", 1)
  end
end
