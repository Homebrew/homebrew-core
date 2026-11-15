class Dnsx < Formula
  desc "DNS query and resolution tool"
  homepage "https://github.com/projectdiscovery/dnsx"
  url "https://github.com/projectdiscovery/dnsx/archive/refs/tags/v1.3.1.tar.gz"
  sha256 "2c14a27b00e3215e1c0dc07afe9e5e5c3f0a3502852f1d5f497a92b5e6cb63db"
  license "MIT"
  head "https://github.com/projectdiscovery/dnsx.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "fe4c102dd538d33c28b1b5fff59ba58de83053a826e0f2e767c518358c9758a9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d8f155e19077e5dd49bfeba1168e8c844a66b68999cc7bd4b0a6cd01dec288c8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2dade74df243915eb10beadaf3635eb968504979fee56a8bffe950239e6aed69"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "3cd7c14111823219ed6dddc03d3885129ea65ef8580e1fa94f560c902cd752d7"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "fecbf61d30c674a68cd896b77534d5945a84cdef1e6d2983efb1eefe872fa443"
    sha256 cellar: :any,                 x86_64_linux:      "85db957c48beec0b6428e6166137f2c07a39ef167e6e3346f512d814779babbf"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args, "./cmd/dnsx"
  end

  test do
    (testpath/"domains.txt").write "docs.brew.sh"
    expected_output = "docs.brew.sh [CNAME] [homebrew.github.io]"
    assert_equal expected_output,
      shell_output("#{bin}/dnsx -no-color -silent -l #{testpath}/domains.txt -cname -resp").strip
  end
end
