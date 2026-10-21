class Gogcli < Formula
  desc "Google Suite CLI"
  homepage "https://gogcli.sh"
  url "https://github.com/openclaw/gogcli/archive/refs/tags/v0.45.0.tar.gz"
  sha256 "500a30dcffc88ab4299c59a2c7e36916f6f5c0d8d215c24ebe482594b785c7d6"
  license "MIT"
  head "https://github.com/openclaw/gogcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "aa4dbeb07865b12874c170cdcb28aeaf6dd8cf2a1715df2a90e5f9466518bb63"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c5160669c09641ec4ec7590354765eed2e5c235ec6b3987fac0a0ba45b42bc4a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9629354d558e2c23806d0356579d6e1353501a042f464832c936e92f58ff339b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b5028925ed4b12745db180f652b03540fe6f005effaf504d4527e8a125457bfa"
    sha256 cellar: :any,                 x86_64_linux:      "a2747f3faa7227e4e7221a89a3a732d4451f27fdca882d6a247bff716c4876f8"
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
