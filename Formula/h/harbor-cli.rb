class HarborCli < Formula
  desc "CLI for Harbor container registry"
  homepage "https://github.com/goharbor/harbor-cli"
  url "https://github.com/goharbor/harbor-cli/archive/refs/tags/v0.0.13.tar.gz"
  sha256 "9d561b504114616cdec0679a95ddabfcc109fed7b0778bac6fdfe71134566b46"
  license "Apache-2.0"
  head "https://github.com/goharbor/harbor-cli.git", branch: "main"

  depends_on "go" => :build

  # defer keyring initialization to prevent build-time keychain errors
  # upstream pr ref, https://github.com/goharbor/harbor-cli/pull/562
  patch do
    url "https://github.com/goharbor/harbor-cli/commit/93f98b72d28fb5d4f02f7931cb5fddcaa56ccd12.patch?full_index=1"
    sha256 "d37e4d7b1fb387c44c6ac0cf70f49f5edb266e29500a0023ba3a22c49379fdec"
  end

  def install
    ldflags = %W[
      -s -w
      -X github.com/goharbor/harbor-cli/cmd/harbor/internal/version.Version=#{version}
      -X github.com/goharbor/harbor-cli/cmd/harbor/internal/version.GoVersion=#{Formula["go"].version}
      -X github.com/goharbor/harbor-cli/cmd/harbor/internal/version.GitCommit=#{tap.user}
      -X github.com/goharbor/harbor-cli/cmd/harbor/internal/version.BuildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"harbor"), "./cmd/harbor"

    generate_completions_from_executable(bin/"harbor", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/harbor version")

    output = shell_output("#{bin}/harbor repo list 2>&1", 1)
    assert_match "Error: failed to get project name", output
  end
end
