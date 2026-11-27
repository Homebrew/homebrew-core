class Gogcli < Formula
  desc "Google Suite CLI"
  homepage "https://gogcli.sh"
  url "https://github.com/openclaw/gogcli/archive/refs/tags/v0.48.1.tar.gz"
  sha256 "faec62b748b7d4d12109eb9ed28e79a592f4a8da06449fe23965a92e48562247"
  license "MIT"
  head "https://github.com/openclaw/gogcli.git", branch: "main"

  bottle do
    manifest_sha256 "aa569416f40efaf7e87d1ba0c04338bbe1de6f7f8b0d7bdb0be81e995daf7de2"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "71e1a6faf0ac03952c37bcb9b60552b3ba27cd92f50a4c3d752bdf21c558210f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "90b9a46ac5b312bfdf0dae266b5576b3aee21df411795a155cea6f146dcf62d9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9bccdf53b0469047ff55ec5626e81906196abc0322d8c43fb06415444fd3f916"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "79d7b8f5fc738b2e291e6d7b3788b351b478feb273d57cb3c534d5a9668e9dae"
    sha256 cellar: :any,                 x86_64_linux:      "855db79477140108c0f4b1e2ffbd09164ff9ba0fdce9483689cca9d0a23dd4df"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X github.com/steipete/gogcli/internal/cmd.version=#{version}
      -X github.com/steipete/gogcli/internal/cmd.commit=#{tap.user}
      -X github.com/steipete/gogcli/internal/cmd.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"gog"), "./cmd/gog"

    generate_completions_from_executable(bin/"gog", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gog --version")

    ENV["GOG_ACCOUNT"] = "example@example.com"
    output = shell_output("#{bin}/gog drive ls 2>&1", 10)
    assert_match "OAuth client credentials missing", output
  end
end
