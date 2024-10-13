class Gmailctl < Formula
  desc "Declarative configuration for Gmail filters"
  homepage "https://github.com/mbrt/gmailctl"
  url "https://github.com/mbrt/gmailctl/archive/refs/tags/v0.10.7.tar.gz"
  sha256 "0e1c4dd9d641a9f68d1016082d842c576bde761ae9eba9b434d944766278e681"
  license "MIT"
  head "https://github.com/mbrt/gmailctl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "3188b7cbf15ab232e5fb242650cd27776361effc1942a7bb9476ac2e2cce9698"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e437e7d93c81fec27997c331a13b565ab8d02942e5612010889581afbbc4070d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3cac5567a901f9dcdc977ebac936c74c15c43d219964f79c8a6acdb3da910751"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8c4d4358f5fcffd42bd0c20e8f565f05947839a29111e8482e2595d4fddc9b4c"
    sha256 cellar: :any_skip_relocation, sonoma:         "e1d7d46948f4cd985d488aadc2e1274a6fb3aefbd32de45e839c2cbe073ac80a"
    sha256 cellar: :any_skip_relocation, ventura:        "43b565f1edff01db5d4a90e17c979935d5f95b25078c1c9986d079a1b05029d2"
    sha256 cellar: :any_skip_relocation, monterey:       "38bdbb5cad55fdb22caf0a243f9ea6897fb5c3bd8272157fbc2e8466d73af655"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b87baba1f581f80753bf26035a9eabeeb933ec05352bdf832355bec4a9cdf53d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "cmd/gmailctl/main.go"

    generate_completions_from_executable(bin/"gmailctl", "completion")
  end

  test do
    assert_includes shell_output("#{bin}/gmailctl init --config #{testpath} 2>&1", 1),
      "The credentials are not initialized"

    assert_match version.to_s, shell_output("#{bin}/gmailctl version")
  end
end
