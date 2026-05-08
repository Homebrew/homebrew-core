class Gogcli < Formula
  desc "Google Suite CLI"
  homepage "https://gogcli.sh"
  url "https://github.com/steipete/gogcli/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "f617696f7d59bada62016c3b968f1ba40e0436fa840d77ac6d03d338a5143820"
  license "MIT"
  head "https://github.com/steipete/gogcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "03663e13be2d9ea247e00baa1558a94f29887ab767c9f2889b5342f930a7d089"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "04e69adc868aa2e94221584c59200387cfef8ba3d7863f4200c2b5489abc0ba0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1d16f8ffb430e661f55c59e3e17792509252cbc193e8e9a1bb3274b08cf697e2"
    sha256 cellar: :any_skip_relocation, sonoma:        "7a5b4e380ca74089177da931d4aaa2790b5098a6294894dfe7c15335351a902d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d41c2c9bf34ba6063eb1315fc5320ff5e75640ba79a9e8998a36f170e6469489"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b7d27e3592d03082ce472bc133323d8084443036092003a2b600e73f7a29c9c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
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
