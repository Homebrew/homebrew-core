class HarborCli < Formula
  desc "CLI for Harbor container registry"
  homepage "https://github.com/goharbor/harbor-cli"
  url "https://github.com/goharbor/harbor-cli/archive/refs/tags/v0.0.20.tar.gz"
  sha256 "3140b3d9a30feef01ecd297856d859bbd544d25445c9eaf8aad05198c91fd462"
  license "Apache-2.0"
  head "https://github.com/goharbor/harbor-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5e5993b3a851d8a079507c97cb90ee337e181d8dde7906026c3bf7c0329c8d60"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c4289d4a517fa7f997124bcd08780fbcd3ded364f3e21dc2529fe6bdee5f0b3b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8498ff592f8a51e02d5ae841e25886f79ca053dacda48ccc1b6be63c6074fea3"
    sha256 cellar: :any_skip_relocation, sonoma:        "d15240ad53735b873a03795c5a56d0efb90d84ccd8296aa0c7dae7bb9619b04f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c662ea4c4ff79379c814dc23a7394e0a14fe61d84106078aa290aa19798383bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b53636d19c482643083e8ad736b04ed519a11af4972b5689217fc813f52f50c2"
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
