class HarborCli < Formula
  desc "CLI for Harbor container registry"
  homepage "https://github.com/goharbor/harbor-cli"
  url "https://github.com/goharbor/harbor-cli/archive/refs/tags/v0.0.22.tar.gz"
  sha256 "c8db729fa244c647f58c88a04bba3244248a19817073ef095efbc1befee3b4d4"
  license "Apache-2.0"
  head "https://github.com/goharbor/harbor-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8d851a9b6229542466685b90bc180e35fb9aa360b667d845167e632ef52a245e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "396cdd8951c59f7a47ffa2195dcb63bdba67197b9855bf53280bd8bec11a6a60"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d0c5e97cbe51956b5b232a17f184b13908231fa114d62700bdec9826392f77dd"
    sha256 cellar: :any_skip_relocation, sonoma:        "875a8fbefc60df638edb255e1497f7f94952c1eb17fa29aa091bcc95e6536422"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5d64ed53c0e0f33022eee8feb1fa39d1a63271f1d8d10b85685996fda23f6b8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "766f8afef29d9693a6ef6c6c42b3768997d19cbaa6886efc4d7458c7277d7a1c"
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
