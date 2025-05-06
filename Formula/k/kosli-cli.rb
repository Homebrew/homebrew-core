class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com/client_reference/"
  url "https://github.com/kosli-dev/cli/archive/refs/tags/v2.11.13.tar.gz"
  sha256 "a4cea94e23cdc42162dab5915d112614702d5212c97e248ce1609b94d0d84ed4"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1caa209dcb32033023b3523f7e2317f1f122deb1c8151367fae8bc1ec4226b7f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2e302e239d8a4dc885fdbd043868e7f0f1aef248f7045bba8f3903ab977f172f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8f625fa2fc35bb242c8c07cc0c7f9f39971318c69c7ff55ae88944f9e2d93f8e"
    sha256 cellar: :any_skip_relocation, sonoma:        "fbc336bb11ada3b6ee037ac385acffeb7a3f9fe89bcd74501d7e73930de8fb15"
    sha256 cellar: :any_skip_relocation, ventura:       "f7f41df19b9b38c7e9cffc34eff8a25c179422d53777bcd5ececdb08bbc81630"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8d23260bb7f5fd5f13b9310c455bcc2ab703935440d8f29540b137aff8d930eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ba0b96993d624dab3f4a37d49c4d93b5b1d091d8393a936878c3123cb38394be"
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
