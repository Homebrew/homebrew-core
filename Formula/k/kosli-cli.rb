class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com/client_reference/"
  url "https://github.com/kosli-dev/cli/archive/refs/tags/v2.15.2.tar.gz"
  sha256 "ca9db9365eac7f4d1b94c725a9bccb0fabd8e9d41d46460376d058154804f327"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "095131d6169069a55695bf8252860ff576fc1208bfe70fffee4e2b126c894936"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1f65345725f1b27a9d08724377c20698c9e228cb8f6a58eb92259b3532bdbdc4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4da41ecff88d686be44280dd85ffcfb4b38ef2f5a4f7077ee6a08246113262cc"
    sha256 cellar: :any_skip_relocation, sonoma:        "aa57f17374dec045a32352a7dfa3dbee7e967c4213f76889d08ea09baf804f1d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dcd57584c3c118457fbe2f6994f536e922ca8c240aff5c2adb1f754a896b61bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d462b30fda2a9217948b419c433ea8174390b8edf2878bdc8f88ba8088e37946"
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

    generate_completions_from_executable(bin/"kosli", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kosli version")

    assert_match "OK", shell_output("#{bin}/kosli status")
  end
end
