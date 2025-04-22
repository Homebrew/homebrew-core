class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com/client_reference/"
  url "https://github.com/kosli-dev/cli/archive/refs/tags/v2.11.12.tar.gz"
  sha256 "2dfc117390f32bfa221c21a3ac666050b99f993fb3398579680df159c117195f"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4389e67f46489ea21301668f3e51562adaa4c44f14b2f978111a5108b0b71ef1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f5baa7e312a2385bbb516853e13548a7b4f0fde1fa6216a4395535849e583936"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "99f443c0ff192f7f0c73629da464c097cf6761ead65e5ab765fc379690fc24fb"
    sha256 cellar: :any_skip_relocation, sonoma:        "93e7b3ade576ec225506320f9f383437167fcf68c17894f62c8d72c0e626c7b8"
    sha256 cellar: :any_skip_relocation, ventura:       "2bfa8d52984c9a58982c799be3658a30ab62178481b0783aacba67509d252b23"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6845fd806a243b147e2f7c771091125ebe9abc11e50d46f9c29136957964152c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "35c6d6c8a91219edb8fcbe3ccbec7838a48059c7950692172806a2a12d895430"
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
