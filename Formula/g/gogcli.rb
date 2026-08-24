class Gogcli < Formula
  desc "Google Suite CLI"
  homepage "https://gogcli.sh"
  url "https://github.com/openclaw/gogcli/archive/refs/tags/v0.37.0.tar.gz"
  sha256 "c44902cfa6c7e98d664bcb8cd961c5d2e4d062ae936175348053ff61a2a8066e"
  license "MIT"
  head "https://github.com/openclaw/gogcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fa9a680f033c623ad7ed7c8055e9efbfe6ab816ca3aa479443e9b193984fb923"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "43c42bdab9ac36e91b8c7bf09f215974de58a87692b41c580d3c5c51830a66e0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "13b078022752a2a485a0c9bdd93ecd32d14386e1ddf3c89fe3242ffd6bb780c9"
    sha256 cellar: :any_skip_relocation, sonoma:        "7f3a9d4e1a9142057692d52fba79130bcac71eea28d189ea98030908d96cd1a5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "02386cad5e064c313f59c9476f3b548338806f007c8c359061dbe2f50068b62e"
    sha256 cellar: :any,                 x86_64_linux:  "a363f34d3fc77d2aa75970a806ecd1886f19c23d8fb6eb9e25fe6cab3599aaea"
  end

  depends_on "go" => :build

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
