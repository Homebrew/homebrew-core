class BitbucketCli < Formula
  desc "CLI for Bitbucket Cloud and Data Center"
  homepage "https://github.com/avivsinai/bitbucket-cli"
  url "https://github.com/avivsinai/bitbucket-cli/archive/refs/tags/v0.38.1.tar.gz"
  sha256 "a4faf80f10042f6a48411d8573fdb9e13035b84bfd1bd0b76ca2c79be4bd08df"
  license "MIT"
  head "https://github.com/avivsinai/bitbucket-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "503b856227917781abbe77a087594c393cb971d1232e8033db247d428ac99cc6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3a7705d01968a33f44471ec5be1676fa2ca83cb05e3d5cdee84c102726c3fe18"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b9fd888848176807c13f12d6c1aaf4d42a6891fcd5a54e616de8a6bc70253963"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "dbda09d5db48ff1254fd33e0525f8de838f87acfa9057a57cde038febd643363"
    sha256 cellar: :any,                 x86_64_linux:      "2b7b0e67737fd317e0c117ecf47c339ebd9bc7f599ea9b448bcb20d973ee0925"
  end

  depends_on "go" => :build

  conflicts_with "bkt", because: "both install `bkt` binaries"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X github.com/avivsinai/bitbucket-cli/internal/build.versionFromLdflags=#{version}
      -X github.com/avivsinai/bitbucket-cli/internal/build.dateFromLdflags=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"bkt"), "./cmd/bkt"
    generate_completions_from_executable(bin/"bkt", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bkt --version")
    assert_match "No contexts configured", shell_output("#{bin}/bkt context list")
    assert_match "no active context", shell_output("#{bin}/bkt repo list 2>&1", 1)
  end
end
