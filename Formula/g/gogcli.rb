class Gogcli < Formula
  desc "Google Suite CLI"
  homepage "https://gogcli.sh"
  url "https://github.com/openclaw/gogcli/archive/refs/tags/v0.40.0.tar.gz"
  sha256 "d7accd30469f127908466d3970647883e69991d22f4b9613d0e393d324abe5bc"
  license "MIT"
  head "https://github.com/openclaw/gogcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7cf9c5003ca6831da314a341ee9ba8fbf0429a357d74ef580185be4a7eb12bc9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0e15f5cf8a3f854a2051aecec6efa668e26dd517574a2d7b72b157390879fab6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d9349190acda98e2a7a355912164b2206e91142f018dbac69bbde77baa2e1282"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "fcec14cbd765af6e0a2df606f3c6edeee252832fda7091706f93425577b89cea"
    sha256 cellar: :any,                 x86_64_linux:      "a108470ada5c7bc64efad39e5526497bc6533107273471e580458f156a7b1df1"
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
