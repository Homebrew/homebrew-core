class Kekkai < Formula
  desc "File integrity monitoring tool"
  homepage "https://github.com/catatsuy/kekkai"
  url "https://github.com/catatsuy/kekkai/archive/refs/tags/v0.2.10.tar.gz"
  sha256 "ab244e24bb957954a0911f0e67eaebc4424179dd4addb79aa31519e6c75a74d8"
  license "MIT"
  head "https://github.com/catatsuy/kekkai.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6da42591ea2227ccd41fac8c0e30110d76e384794b827c45cbfd175749f95ac9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6da42591ea2227ccd41fac8c0e30110d76e384794b827c45cbfd175749f95ac9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6da42591ea2227ccd41fac8c0e30110d76e384794b827c45cbfd175749f95ac9"
    sha256 cellar: :any_skip_relocation, sonoma:        "0db1ece8166e533e72cc7a00b551d4c11bdc2e7e79b9bddc1b600a2a0bb081c9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e910d64f127b33c5daaea5bbdf9c90081ff1219a2ba1d8ead6a5dd5104a0f691"
    sha256 cellar: :any,                 x86_64_linux:  "a15dd7916120e50ab2ce46ae711fdd3c998463c7e996925c1da1eff508c585a8"
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
