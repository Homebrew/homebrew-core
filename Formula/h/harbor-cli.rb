class HarborCli < Formula
  desc "CLI for Harbor container registry"
  homepage "https://github.com/goharbor/harbor-cli"
  url "https://github.com/goharbor/harbor-cli/archive/refs/tags/v0.0.18.tar.gz"
  sha256 "b83cf763b0b54306eedd39d9adb99fa5a2d9badcb872a2aa64ca8a552433bb48"
  license "Apache-2.0"
  head "https://github.com/goharbor/harbor-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4776a705b217a1ad5d8fda3cdb79bb02356ce5260f30d7a9699856089e2b3b36"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4776a705b217a1ad5d8fda3cdb79bb02356ce5260f30d7a9699856089e2b3b36"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4776a705b217a1ad5d8fda3cdb79bb02356ce5260f30d7a9699856089e2b3b36"
    sha256 cellar: :any_skip_relocation, sonoma:        "0c69da44fd31a11680bef821fdd6bc62503797df192464377ab24817c832d3f0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4e43dd2908c74bf7dcbb36f8137fb550e5bf2aa31dd63ac416c03afb9b7f403f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f3168c19e5862bd7b3dd6e11e7d978ee50b411ac0bf8aeb6b20f965d3dff772"
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
