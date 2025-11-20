class Kekkai < Formula
  desc "File integrity monitoring tool"
  homepage "https://github.com/catatsuy/kekkai"
  url "https://github.com/catatsuy/kekkai/archive/refs/tags/v0.1.6.tar.gz"
  sha256 "e4a525fbfc87e0fc6b5de83b70c5b688367e5501861667e0b6b038ebac0f0e8d"
  license "MIT"
  head "https://github.com/catatsuy/kekkai.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d27c2cda79d65fd2e545553f40bc0002405f53a31413e081e3c62ca22a38010a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d27c2cda79d65fd2e545553f40bc0002405f53a31413e081e3c62ca22a38010a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d27c2cda79d65fd2e545553f40bc0002405f53a31413e081e3c62ca22a38010a"
    sha256 cellar: :any_skip_relocation, sonoma:        "47c613c12ac61be5b1a25d14adc22fe154d321fc037d81588665221785391722"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bf7a1d8fd9ec064030e18ba4d2b156f967d68386b030e3cf451550afd030bf84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cde32d3555286be42bb474c1096c6af3651fe4e1a5027d630f14d626dbf16085"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/catatsuy/kekkai/internal/cli.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/kekkai"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kekkai version")

    system bin/"kekkai", "generate", "--output", "kekkai-manifest.json"
    assert_match "files", (testpath/"kekkai-manifest.json").read
  end
end
