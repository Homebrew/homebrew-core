class Kekkai < Formula
  desc "File integrity monitoring tool"
  homepage "https://github.com/catatsuy/kekkai"
  url "https://github.com/catatsuy/kekkai/archive/refs/tags/v0.2.5.tar.gz"
  sha256 "ba57b93d114ea6183d9f3fddd5907c55d11d67e04e185b65997c1205872b607f"
  license "MIT"
  head "https://github.com/catatsuy/kekkai.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0be4e5816e8149546892aae46fab73aef281443789d3c683d9564f4f1772e6ad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0be4e5816e8149546892aae46fab73aef281443789d3c683d9564f4f1772e6ad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0be4e5816e8149546892aae46fab73aef281443789d3c683d9564f4f1772e6ad"
    sha256 cellar: :any_skip_relocation, sonoma:        "f9698b009751321eb8527aee1a65c9f3dd2145da2bd65ec99bf332ff2bfd1f6c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "47edf48ea24fe34573f826d4f985c926d2050ce2845bdcbb4d178033f3ca67a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "596f8439741e71684e5028c3af62f1939bfb6b2a3d2184b4bdc17fcdc3bc9446"
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
