class Kekkai < Formula
  desc "File integrity monitoring tool"
  homepage "https://github.com/catatsuy/kekkai"
  url "https://github.com/catatsuy/kekkai/archive/refs/tags/v0.2.13.tar.gz"
  sha256 "98e52e7f2b57405395fd3d7799fe53cce259982965e8438d5d3e5d4ac8a03015"
  license "MIT"
  head "https://github.com/catatsuy/kekkai.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f858b8c934c378a8ead7b9bb5b8f17f2c5de51bcfba0009eec769b3cdcbfac38"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f858b8c934c378a8ead7b9bb5b8f17f2c5de51bcfba0009eec769b3cdcbfac38"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f858b8c934c378a8ead7b9bb5b8f17f2c5de51bcfba0009eec769b3cdcbfac38"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4e1673ddca2059446ebed653e571582d560d3940a4f85e52accb9237249a71ae"
    sha256 cellar: :any,                 x86_64_linux:      "7b92bc630db01a243dbe0032b18f7cd98de38af4e00d82ab455b95ea3d118214"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X github.com/catatsuy/kekkai/internal/cli.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/kekkai"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kekkai version")

    system bin/"kekkai", "generate", "--output", "kekkai-manifest.json"
    assert_match "files", (testpath/"kekkai-manifest.json").read
  end
end
