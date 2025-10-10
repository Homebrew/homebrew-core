class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com/client_reference/"
  url "https://github.com/kosli-dev/cli/archive/refs/tags/v2.11.26.tar.gz"
  sha256 "929d45b0046127fea8faa588962d52ee3e705990107b19962bb154ad3dd3de02"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4ddb8f709ff70648a361428dda353b687dfb0f25cf3acb103005d924366704d4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "781033c244d3583205ea7f4e651245e64be4269f6a608f9a634b42467dba0bb9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "12f131db47efed38175d9b209990c634d1f69c87f927553a5091581176f9f36c"
    sha256 cellar: :any_skip_relocation, sonoma:        "0d5622cc4b6958e3ca0d87626b3ac59d43827044b3af28e5dec2b401980ec267"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3b5106d4514ac4e3898c780ad88805715235a45889dde4dd1804b715ed7f1f2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "191df05b11b14b5c3ba27d6859db4d5994d31817df59addcc5de27123fc069da"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kosli-dev/cli/internal/version.version=#{version}
      -X github.com/kosli-dev/cli/internal/version.gitCommit=#{tap.user}
      -X github.com/kosli-dev/cli/internal/version.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(output: bin/"kosli", ldflags:), "./cmd/kosli"

    generate_completions_from_executable(bin/"kosli", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kosli version")

    assert_match "OK", shell_output("#{bin}/kosli status")
  end
end
