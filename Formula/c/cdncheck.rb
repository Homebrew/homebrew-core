class Cdncheck < Formula
  desc "Utility to detect various technology for a given IP address"
  homepage "https://projectdiscovery.io"
  url "https://github.com/projectdiscovery/cdncheck/archive/refs/tags/v1.2.28.tar.gz"
  sha256 "476cb9bd70dbcb445f75d85b5c2ac5393e5fc0c1ad5a858bdfd6706f40fb4685"
  license "MIT"
  head "https://github.com/projectdiscovery/cdncheck.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "73adf2f59a6ced60f839b721855497dbba4aa8d1af2144b4b844bfb33f9dc0ad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d552defc50ab9d3ea2f89926953d4f9aeaebf1996f7f7f28d3ba3a7c8c9b9e5f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "56a0a229ce7ce979eec7854c56533c9888d9d1cdcb4bd8e27f54060bbb3a6ce3"
    sha256 cellar: :any_skip_relocation, sonoma:        "2577517d15c2be1aa2fef3208667c535c9a023120a9deff1b852197a872ebf75"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ac949816384a80a9836700a441f060dd985ca2b40b856071a0b8736062195a76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b5bbb402bdca7670b99f5d08bc060579051e4b886367ef852bc4526a6ec9a58"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/cdncheck"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cdncheck -version 2>&1")

    assert_match "Found result: 1", shell_output("#{bin}/cdncheck -i 173.245.48.12/32 2>&1")
  end
end
