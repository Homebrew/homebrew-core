class Nuclei < Formula
  desc "HTTP/DNS scanner configurable via YAML templates"
  homepage "https://nuclei.projectdiscovery.io/"
  url "https://github.com/projectdiscovery/nuclei/archive/refs/tags/v3.2.7.tar.gz"
  sha256 "221a27ec3651efc1c73de4457a13ca73759ba683d197be31548d96fa54a114e4"
  license "MIT"
  head "https://github.com/projectdiscovery/nuclei.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ab9661a373661ccf510c5b5b94c55fa88dc978a7c0ac15731b4fcd9beb0ca767"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d3b5dc697ec9518aeee7fe47a09154721cd9698da8d4f5f6e4117b92074d8b47"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a8e4f4e4b9f2a759b2f4fba3f9f80456be3afe59dd7ead73a3ab45329c832675"
    sha256 cellar: :any_skip_relocation, sonoma:         "96f049297e3f91c37ccb4325a49eea900c1fe2eaf35cca9f30fbea5140067c47"
    sha256 cellar: :any_skip_relocation, ventura:        "ba4901c7ec05d0366d7480f981e672764780e1fa1325c5166b11baaaa3158db9"
    sha256 cellar: :any_skip_relocation, monterey:       "a7599fde6b5acc095b58f45f2187fc965a68a1440814ca4d58534b1cb846ab53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0614ba7763a5e2aba29e0c3f5cf234894150fd0d9b1c34d7bff40add69ab98ee"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/nuclei"
  end

  test do
    output = shell_output("#{bin}/nuclei -scan-all-ips -disable-update-check example.com 2>&1", 1)
    assert_match "No results found", output

    assert_match version.to_s, shell_output("#{bin}/nuclei -version 2>&1")
  end
end
