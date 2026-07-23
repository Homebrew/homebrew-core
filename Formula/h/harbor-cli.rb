class HarborCli < Formula
  desc "CLI for Harbor container registry"
  homepage "https://github.com/goharbor/harbor-cli"
  url "https://github.com/goharbor/harbor-cli/archive/refs/tags/v0.0.24.tar.gz"
  sha256 "3bcd4d8119cb392d863346f9d71b91468e1546e8257f5c59ee15231be3aaf0a9"
  license "Apache-2.0"
  head "https://github.com/goharbor/harbor-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b2e506ff03c82a8206f2faf32398079ec59b40c40d131dea9e8b4735e6f32468"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8bd74546becdd87150b8cbacc93bc1c46d915915e6e6b8767a9bbe0242ac91ac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1494710a8a055994c2df7f4540f0eec9e92df4cd8641931f896e2a404fed5f82"
    sha256 cellar: :any_skip_relocation, sonoma:        "6755c241c9d5ebc07b934dd3c92058b700ae208294a6ad9db201159f03757e56"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a173a400b37144e29f0f4707abc71445d112a816860420d0706285e3addc8928"
    sha256 cellar: :any,                 x86_64_linux:  "c1194a54921aef6aeeffe5db0f61b9be7b4bd79f945e044bc0cd7c0b61eaf33a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/goharbor/harbor-cli/cmd/harbor/internal/version.Version=#{version}
      -X github.com/goharbor/harbor-cli/cmd/harbor/internal/version.GoVersion=#{Formula["go"].version}
      -X github.com/goharbor/harbor-cli/cmd/harbor/internal/version.GitCommit=#{tap.user}
      -X github.com/goharbor/harbor-cli/cmd/harbor/internal/version.BuildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"harbor"), "./cmd/harbor"

    generate_completions_from_executable(bin/"harbor", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/harbor version")

    output = shell_output("#{bin}/harbor repo list 2>&1", 1)
    assert_match "Error: failed to get project name", output
  end
end
