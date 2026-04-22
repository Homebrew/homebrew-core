class Gogcli < Formula
  desc "Google Suite CLI"
  homepage "https://gogcli.sh"
  url "https://github.com/steipete/gogcli/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "2463dd2e302e948e9271542c7dbeae680c9c4885ccf92005f2fce0e5a2b59809"
  license "MIT"
  head "https://github.com/steipete/gogcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a30821c4da7aa97280d45dcd1d24afaf66e50752c0fda152f859f242718d35d4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dc1f68d5dcdfcb6447f2d3665c14a312f14df147d388dc8ce6dba608fbe0f029"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9be5eed839c4ffd0a428edd01b7f3c7571a09a6cbd477464aad2033c70150633"
    sha256 cellar: :any_skip_relocation, sonoma:        "57f4d222532a1f062ce91dcca36ff9199ea0cd4a1e19df8222079e8474d19e2b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "86f3f95fb293a09af3e82ee860ddbf271773785af17d629906d7e6aa8b1932bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a590e58e7411e98f95c3b0741d78fa036a0f126b3af0856df9c0e258c83ac90"
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
