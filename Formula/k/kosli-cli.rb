class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com"
  url "https://github.com/kosli-dev/cli/archive/refs/tags/v2.53.0.tar.gz"
  sha256 "d5835b92fee81f2e4e3c97571357f6790761608597cd8ac4a13dd8bf33022831"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5f0d1f6ea08bd4cd72df148bd238867748ad18873cdf2f5104ca2f2d54df5be0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "374122ede8ba4f6971bc2f405cdf123d4d5cdd4081239ce17bcb38d542390bc2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "73a8e30828da07fb2a4777ae5020fc00f60e764723c6601938567047831db3ea"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "5667ea81f844c6d4c4d6b22d95a9b817a540b5471fdfd819b53ec9684c404940"
    sha256 cellar: :any,                 x86_64_linux:      "a8b30e8ad1f255c69799f0d0666ff26bf185c7ef1de242fe83f743f9b2c50510"
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
