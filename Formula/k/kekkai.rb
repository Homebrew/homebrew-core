class Kekkai < Formula
  desc "File integrity monitoring tool"
  homepage "https://github.com/catatsuy/kekkai"
  url "https://github.com/catatsuy/kekkai/archive/refs/tags/v0.2.6.tar.gz"
  sha256 "ccb029574e7b0240c1aacf5847c6a09cc9f6991dc8ae25b594891b09634657dd"
  license "MIT"
  head "https://github.com/catatsuy/kekkai.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6d8df5d93ecab2d1be9b30c0e5aaa688e0a155df267acc0d4424469a19d8d6fe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6d8df5d93ecab2d1be9b30c0e5aaa688e0a155df267acc0d4424469a19d8d6fe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6d8df5d93ecab2d1be9b30c0e5aaa688e0a155df267acc0d4424469a19d8d6fe"
    sha256 cellar: :any_skip_relocation, sonoma:        "9d2fbefa1dda95ad6afe34004d1af0e4d9a1d20d7a940fcf7573bf3b3bc26041"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5582a031cfd37d8cde6cac6d0abdbaa556cb759a64569f533fe69977bda08db4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4fb6026058379421392b02de7408ebf8c0edef798c3c9956487d926aa1b80a7c"
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
