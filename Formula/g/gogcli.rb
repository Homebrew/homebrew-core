class Gogcli < Formula
  desc "Google Suite CLI"
  homepage "https://gogcli.sh"
  url "https://github.com/steipete/gogcli/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "6d0f9e91980dfc38bb91638c0439dfc91823add1689b65e31419ba9989db5897"
  license "MIT"
  head "https://github.com/steipete/gogcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "31752579a902a6ccf11193860beea0817e7a534a7b3e345f83e483165768ddba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "16c1f87c30423675f94f1a24b994a395878e2a6bc6bce6d769b814a0fba93e3d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7536182d683960643c660c4ee584377a1fe5c81adc442bc95b54b7225dd93b39"
    sha256 cellar: :any_skip_relocation, sonoma:        "5f96d925dc0294595b6eec98a24bcc52d8588cfa3cd6262195db7169b10fcb33"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7d113eaa0ee259c65fa22c739e3a47f6f7a781098dd22dd9c31bf0f5aeaab6d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c91891c9c33c6534ecf396665357fd9696b4f827210f721836c1e1a5dce34f25"
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
