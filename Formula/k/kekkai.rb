class Kekkai < Formula
  desc "File integrity monitoring tool"
  homepage "https://github.com/catatsuy/kekkai"
  url "https://github.com/catatsuy/kekkai/archive/refs/tags/v0.2.9.tar.gz"
  sha256 "850922716fa9d4efd270261ca5de050d85d775a28cdc3a289fb9e9e3f7f5e495"
  license "MIT"
  head "https://github.com/catatsuy/kekkai.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a731da298229d21e640343d63dd7750fd2c11df50c5043d266c9718e913894c7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a731da298229d21e640343d63dd7750fd2c11df50c5043d266c9718e913894c7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a731da298229d21e640343d63dd7750fd2c11df50c5043d266c9718e913894c7"
    sha256 cellar: :any_skip_relocation, sonoma:        "23acf6a941bc110a695ae53e37f80a93c7754ab6f80b98bffeae624ed755ab11"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4000b29d033c381090d0454c547fbff0a64f9193cf789de2de5a10f5126a17ba"
    sha256 cellar: :any,                 x86_64_linux:  "34630246554e3422f9fd985d94641d1884f857f7e9e3e02c6d49cc3e5bacd837"
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
