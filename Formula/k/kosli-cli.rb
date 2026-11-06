class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com"
  url "https://github.com/kosli-dev/cli/archive/refs/tags/v2.55.0.tar.gz"
  sha256 "42741aa5b11762bef860c70d81eddf3cc79c7a46123e10e057520c6c54b44af8"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e167d92d940b93cfd965c921fd1872e5654ca0d0d7fb4fb6acc323245bc686e4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "42b9d79e32c06cf6595fecad406283cc2335d5d061fe6d0219b1e4792466f871"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "954f9fa2f902ba0e5507e160515d49037f309ef5bdc4c2ec01e08c7988a00da6"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4e31158feda7e20a1af84f57524bdb33e8d69b2404a028bdafbf6841384a60be"
    sha256 cellar: :any,                 x86_64_linux:      "cb72a86e73371b00fce7be8140352b8c2a230483cb2304f3fe441039d8dbb811"
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
