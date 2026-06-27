class Hey < Formula
  desc "HTTP load generator, ApacheBench (ab) replacement"
  homepage "https://github.com/rakyll/hey"
  url "https://github.com/rakyll/hey/archive/refs/tags/v0.1.5.tar.gz"
  sha256 "f678bc0f07c62a6513726298873940b70099aa85244efa813f6a0d925092ffe9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2e6a32dc6db2049f5db08ae59f3e6028a97cfcaba825e1009c13ea4e61f24891"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2e6a32dc6db2049f5db08ae59f3e6028a97cfcaba825e1009c13ea4e61f24891"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2e6a32dc6db2049f5db08ae59f3e6028a97cfcaba825e1009c13ea4e61f24891"
    sha256 cellar: :any_skip_relocation, sonoma:        "9eb4bb90608a7aa8696dc46499a68b61232adc9025891569240964175d1f35ef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "967741f2dcee79b7d0aba61b87753b4eff25cd8b74d0010a90205fa6ae5d7b3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e7a5f536f001bef14f22277de52a94e50619e2800b9600ce107337f8ac9640e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    output = "[200]	200 responses"
    assert_match output.to_s, shell_output("#{bin}/hey https://example.com")
  end
end
