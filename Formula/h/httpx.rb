class Httpx < Formula
  desc "Fast and multi-purpose HTTP toolkit"
  homepage "https://github.com/projectdiscovery/httpx"
  url "https://github.com/projectdiscovery/httpx/archive/refs/tags/v1.7.4.tar.gz"
  sha256 "90f4132d017d3c7e2bf680fafe9175ce11af4874953c815879071d1c96927944"
  license "MIT"
  head "https://github.com/projectdiscovery/httpx.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "41f6f271c353137041556c5cfcf2f9438fcaca70ee24a0dec2ac31ffe4e98fa9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "68f0f7c0ba12b0f459900fef23aa2cf757d9196b7702325678e335038a153e79"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1ce9cf31d67fde15e665d48bb97a863fe8a93953fbd38f820d6c742b4c7b6fe7"
    sha256 cellar: :any_skip_relocation, sonoma:        "f01dc6f1aa1071a5c442e7f9929eb5e6e817d0c34123205c86fec8faf5bb5dbd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b66e90c5ea5142481848d3a8cf517abb76d37a2b497b3cc052b806954b974454"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc375d408f24af36064ddde34e7e0d1fe2399346789b40148b8d7704f8937c1a"
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
