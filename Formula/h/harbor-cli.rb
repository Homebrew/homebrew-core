class HarborCli < Formula
  desc "CLI for Harbor container registry"
  homepage "https://github.com/goharbor/harbor-cli"
  url "https://github.com/goharbor/harbor-cli/archive/refs/tags/v0.0.26.tar.gz"
  sha256 "2ce6c95839de85ac0dfa7f908faf486d11a7ac2cdaac3b8b27e75ccdb59c81a7"
  license "Apache-2.0"
  head "https://github.com/goharbor/harbor-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "75d38377c0081bfac5b17108aee885bd4cfd4e4162f284c7a6763d2e861b3951"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bf6cf1a20aa02b391083da46686815a922256907eac228d9e12c3c49c04550cd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "53b43eef46b7d9c30c5a6440dc63cbd69697e9815b84a5d8e3727ef4dac2558f"
    sha256 cellar: :any_skip_relocation, sonoma:        "f1928085497768837398421ce304ed1eeccc64495f09b94fa7ca0fd1396230f0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "227d92d12d90bdebe5c4307e5f7262c4a020f5c7fa4e077724bf47856c947e1c"
    sha256 cellar: :any,                 x86_64_linux:  "aba31f343be1d2de2e288e0c029618aac70a21a969c752ff628503d86f26a5cf"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
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
