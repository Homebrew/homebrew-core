class Httpx < Formula
  desc "Fast and multi-purpose HTTP toolkit"
  homepage "https://github.com/projectdiscovery/httpx"
  url "https://github.com/projectdiscovery/httpx/archive/v1.2.8.tar.gz"
  sha256 "02e4f6ae1a3f962771fcfeebc7b51fadcaa7eec799069f8e5d845ba69512ff04"
  license "MIT"
  head "https://github.com/projectdiscovery/httpx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3efdb9934a8a3ee226d2a70b8ce404a91adf324ab96e5b6db29c3ce9616ee9c6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "299fffcf8f5c9089a41af4e6d4375442e01acfa28bdf541dc32074d37183e65a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "881c6d00fc32be8c76f04853271c697c94772716bdcb0b4f6f3aabf1518a46c5"
    sha256 cellar: :any_skip_relocation, ventura:        "5d7b008cb86db2d69196a511c0eaba89aaffe0dffce15e78f62d6c88b918dc7e"
    sha256 cellar: :any_skip_relocation, monterey:       "c4fa1dcbf8130c1ad0c56ab9bcbd126b187ef3c3cc6c967265eedb21ce9ff5c6"
    sha256 cellar: :any_skip_relocation, big_sur:        "f693b26ad77ad9b371b0749d0ed2b9c32b186aba3c4562cbfbd788283423e613"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff5dfa75ad771229bf3d65558f2517c81a1769920913fb1f797ed09bb6b3bfd6"
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
