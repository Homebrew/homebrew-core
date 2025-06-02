class Favirecon < Formula
  desc "Uses favicon.ico to improve the target recon phase"
  homepage "https://github.com/edoardottt/favirecon"
  url "https://github.com/edoardottt/favirecon/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "f86508313ece963c8bd173561bf2d3e98fd995a762acc2f8e4a071f695e6759d"
  license "MIT"
  head "https://github.com/edoardottt/favirecon.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3b9ac42b2464890e8bacb8cd97078d61076acef1606c6afd39d0d79a091006e6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3b9ac42b2464890e8bacb8cd97078d61076acef1606c6afd39d0d79a091006e6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3b9ac42b2464890e8bacb8cd97078d61076acef1606c6afd39d0d79a091006e6"
    sha256 cellar: :any_skip_relocation, sonoma:        "da8cfe24f334fef7b605c84b56ff15f914e6104ce404c6f6bf15311449f9a21c"
    sha256 cellar: :any_skip_relocation, ventura:       "da8cfe24f334fef7b605c84b56ff15f914e6104ce404c6f6bf15311449f9a21c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6143cce613537c5a78774e7a52e1063a690a1ace00146fc6af9cff593d89692d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/favirecon"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/favirecon --help")

    output = shell_output("#{bin}/favirecon -u https://www.github.com -verbose 2>&1")
    assert_match "Checking favicon for https://www.github.com/favicon.ico", output
  end
end
