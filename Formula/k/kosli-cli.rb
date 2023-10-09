class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com/client_reference/"
  url "https://github.com/kosli-dev/cli/archive/refs/tags/v2.6.10.tar.gz"
  sha256 "c11162df1bfb6f399e753e14f85be211950eedc004b8e21cebc1e17e06b4253c"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c88741ace104fd50024e2ca0af587b14f20528b73864591093d0366b5a818a01"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "229e800a14ccb74493b09640e8dccafb591556448fa9527f717c39ad5436562e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "89e64dde5ddbcf8f7aaca08ebd77191ffbcb29295950cb25e2b3961d2b5ccbf0"
    sha256 cellar: :any_skip_relocation, sonoma:         "c18c541b6c33fcbd6201bcb2e68f3cd9284fe8e2c4e362778f03eb1cf99fd08b"
    sha256 cellar: :any_skip_relocation, ventura:        "8cc2163e8fb1625d0669c0cca0e0894c8488fe2b77383c671e95a189dd25cee5"
    sha256 cellar: :any_skip_relocation, monterey:       "b2ded3c799dc63ff19978751a7f78a133f2f36b58419c3559e5945953f7b01ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4537ada4dbc4575f38d6031aab0fc62c036fe58b716d1135e7332ca866a5e216"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kosli-dev/cli/internal/version.version=#{version}
      -X github.com/kosli-dev/cli/internal/version.gitCommit=#{tap.user}
      -X github.com/kosli-dev/cli/internal/version.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(output: bin/"kosli", ldflags: ldflags), "./cmd/kosli"

    generate_completions_from_executable(bin/"kosli", "completion", base_name: "kosli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kosli version")

    assert_match "OK", shell_output("#{bin}/kosli status")
  end
end
