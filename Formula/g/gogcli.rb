class Gogcli < Formula
  desc "Google Suite CLI"
  homepage "https://gogcli.sh"
  url "https://github.com/steipete/gogcli/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "672bb7805653b7e62f26cc527352202fe313b821a8c543f7a38a065c7204b6b0"
  license "MIT"
  head "https://github.com/steipete/gogcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "af4e0ca4eafcc538e670fd6f9ed4110d1e6bc5f03e73ddd49774c0de43278be2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "68f1fba0f9714b8824a91b9231693ba980619b9a6ad622d1908760d3eb7760e5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7d4e2172951bfec7969d35b04f3207bd5fa51c74bad436c11f8095d216b2d222"
    sha256 cellar: :any_skip_relocation, sonoma:        "0869c38643efc44062b881e497eee74820ac743b3fe93780b23b84a4c5016aa6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5963f8b09a64fe9ca484037c9e10bf9dd913c2083022a8a4c094075003926ed9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "779e8c797ddcd2696c44f5ebc2ee2720f227522bb58c37739f722ed28ce81a19"
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
