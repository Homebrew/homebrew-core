class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com"
  url "https://github.com/kosli-dev/cli/archive/refs/tags/v2.55.2.tar.gz"
  sha256 "9d617f8e0249a29cbd006416c999474e6e5f5851c11b21cb4a6ca43107f6d3e1"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "151721069dfa9d94502c762c630038b4b2d125893cb9eb3a3d14f756dfce5638"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f09e222ef47518993ca1fa1202dcb3bf6b41c87d01ec01eb34c480caaeaf800b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "dd3a3c9895b2c5b97b3fa83965233f7b7b35ab6498a5bd566ae886a874f297c5"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7d20f3ac97ddb7fcb9417569d951dab30da1857daa6294ed9be18ae9b0070188"
    sha256 cellar: :any,                 x86_64_linux:      "67e104246c4b40ede3a47ae8cba4c89a51212953d08a0db9be52034a5e9fbe31"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
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
