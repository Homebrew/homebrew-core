class Httpx < Formula
  desc "Fast and multi-purpose HTTP toolkit"
  homepage "https://github.com/projectdiscovery/httpx"
  url "https://github.com/projectdiscovery/httpx/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "87c4ac6df00371e6ba8bfc7293400f02ce30391dfa9995cec032c86935135e1d"
  license "MIT"
  head "https://github.com/projectdiscovery/httpx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "202b2510d9f53f3456f157db05066b75ded63ce2886a0b0d5d1e28f85214e05a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d834b64dcb5fd05b400242e236f2efd3116f2ad36c68b71e0056378b66470e81"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0a614d0983327317f0c39400cc9142b72156ec5e2e6136f6883c8ba1b51d1cc9"
    sha256 cellar: :any_skip_relocation, sonoma:         "c896c4aea56afab71f0aa425eb531efa11a3f092daaaf2e43350e5760a0a60c1"
    sha256 cellar: :any_skip_relocation, ventura:        "ea1fbd889981d4f1e002b0f8425dc1bd231efb429135a2844d0e4484ab3510fb"
    sha256 cellar: :any_skip_relocation, monterey:       "8cb808607462bab7480b89042098fb6fe79b62edb6999b1a07b4924cc67fc006"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d2294677f591c6bedcb82a325ada12f723aced5b7d6a552016d1112c20d6297f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/httpx"
  end

  test do
    output = JSON.parse(shell_output("#{bin}/httpx -silent -title -json -u example.org"))
    assert_equal 200, output["status_code"]
    assert_equal "Example Domain", output["title"]
  end
end
