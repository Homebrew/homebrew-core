class Gogcli < Formula
  desc "Google Suite CLI"
  homepage "https://gogcli.sh"
  url "https://github.com/steipete/gogcli/archive/refs/tags/v0.31.1.tar.gz"
  sha256 "683c02e4ed229fed5e51ec78b0d24ee5cd3e06651e6ce9726cdc060063d3db73"
  license "MIT"
  head "https://github.com/steipete/gogcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "027f58f68f446e33bfb71a7b346650384615e205f0ae3c674eb6ec5b3c76139d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "01596f7827c44504f507309ac9faefa2dfe814f2b34846ed6665637113715a28"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f851ca0cf5d0ae3cfb0638d1b6143ac5d7add8462592cdd252d0919f9fb96098"
    sha256 cellar: :any_skip_relocation, sonoma:        "304f37960d538fd64352b8644775323dfc6ff4014013ebc1e858bfee97c4dc86"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d9bf70493edc313974343540349f12e3594d73d30eb41f4a25074af40acdedb5"
    sha256 cellar: :any,                 x86_64_linux:  "5c89e9075472880819f404e41a9557c854658b506ff26175ac7de5e6bcc0f727"
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
