class Ghorg < Formula
  desc "Quickly clone an entire org's or user's repositories into one directory"
  homepage "https://github.com/gabrie30/ghorg"
  url "https://github.com/gabrie30/ghorg/archive/refs/tags/v1.9.2.tar.gz"
  sha256 "178eb5cdbf471f844b5e16c83941125e105a2fa570fe2073a40382f04279d567"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a7abf4581468dffb2060f81de4c0e9ac759f1a99aa0efe86a94d8a13c593e11f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c751452db031197c804e0fe55315dd84363e9f7bf6e056d18484ec1a81e90f73"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c7b04c3b58d85bd80b4f8beda5bd57c9e538a86d01bb116ef5377e04b86f2cea"
    sha256 cellar: :any_skip_relocation, ventura:        "165c31e3d62cdbf4580f5d195154ff2c0a2e7ff449e2ee4ea4719e5ee2805ad6"
    sha256 cellar: :any_skip_relocation, monterey:       "01cb99dcba7c1134a7092bae50bcdd5c60b914936183c3dbf6b260c799136f03"
    sha256 cellar: :any_skip_relocation, big_sur:        "06432777c7c33cc594c22f0b956a29bc5ac03abfd1a86c61450dcff9cd82479b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d73054916819f2fad76444f08867677968b47ddcfcd38913229688636551526d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"ghorg", "completion")
  end

  test do
    assert_match "No clones found", shell_output("#{bin}/ghorg ls")
  end
end
