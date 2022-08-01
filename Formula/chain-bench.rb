class ChainBench < Formula
  desc "Software supply chain auditing tool based on CIS benchmark"
  homepage "https://github.com/aquasecurity/chain-bench"
  url "https://github.com/aquasecurity/chain-bench/archive/v0.1.3.tar.gz"
  sha256 "46b63528ddd0e09b65539a69aefbf4229343e636854d0dd5a241870717843423"
  license "Apache-2.0"
  head "https://github.com/aquasecurity/chain-bench.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "22006efe31216dd66d00a2ab5e17a82aa798bfc270cf7256722b8cd9b3bc9d6c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6be5250cb83710943d4f0966ebc6dc0e9cf635e12216ac855382131cc42dfe7b"
    sha256 cellar: :any_skip_relocation, monterey:       "f65e5d9f17d95f41e406f86c83b8f1ad6fd47660b9971bd87644a97661a4cfc2"
    sha256 cellar: :any_skip_relocation, big_sur:        "f063e6bc1448424b54a2ee644d72574704ece8de749cc0402a29e7de7cddef3c"
    sha256 cellar: :any_skip_relocation, catalina:       "b3bcf78ab76e0069465e68d944facdacaae0b87d3f7cabf20ed7e644016d6012"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "532e867459a3a6c0e8ca3b049e426904461c9ced9da2e4f6545dd6eb1be39e24"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X=main.version=#{version}"), "./cmd/chain-bench"
  end

  test do
    assert_match("Fetch Starting", shell_output("#{bin}/chain-bench scan", 1))

    assert_match version.to_s, shell_output("#{bin}/chain-bench --version")
  end
end
