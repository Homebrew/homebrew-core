class Dnsx < Formula
  desc "DNS query and resolution tool"
  homepage "https://github.com/projectdiscovery/dnsx"
  url "https://github.com/projectdiscovery/dnsx/archive/v1.1.0.tar.gz"
  sha256 "5cb53066b689982be0d08322c40a82320888184cf5ee2a7fce118d566261de20"
  license "MIT"
  head "https://github.com/projectdiscovery/dnsx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8442bb5a58c6aa903e9190b9d8517c7b82dfe4d93cd356018c652da5030ed706"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ea96682c14c48bb5078f285dfa289c58119a97c2132b3544961f39711532c074"
    sha256 cellar: :any_skip_relocation, monterey:       "2174e1da2836796f0b0122a1bcef9a0a8a41a8c02b56c04f555b0e7509c209bf"
    sha256 cellar: :any_skip_relocation, big_sur:        "f828ceee9507469f4b6be91652bfe262f4963593e040a931f0cf6362d13c95eb"
    sha256 cellar: :any_skip_relocation, catalina:       "da6129ba9781e85b1281297f9a83b415d65f331011c1112d8da6a2f713d8f55c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5505a6b622555594c354ded016cc6f1f7e2fcb1cf302edf90de4a4fe9cf60341"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/dnsx"
  end

  test do
    (testpath/"domains.txt").write "docs.brew.sh"
    expected_output = "docs.brew.sh [homebrew.github.io]"
    assert_equal expected_output,
      shell_output("#{bin}/dnsx -silent -l #{testpath}/domains.txt -cname -resp").strip
  end
end
