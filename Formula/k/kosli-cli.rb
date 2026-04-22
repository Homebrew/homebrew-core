class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com/client_reference/"
  url "https://github.com/kosli-dev/cli/archive/refs/tags/v2.17.0.tar.gz"
  sha256 "6bdbf7d869ec0f57e2c6be091c32671bad7768a08ea7d5e9a4ef2e588d7bc729"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8a3a60470d0ddf780efd2dea7ee92cc81f98fb8bcf00da819404646e9c6d2490"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8cda84281770f761678f060eef1713dcdf031a1cb8adf56e6d60f08e0ded6c1e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "37b25221f8ff6b6d5a5e9c166281d2696ef79f401660bf2cc325fc3f6d63cb0e"
    sha256 cellar: :any_skip_relocation, sonoma:        "c7a2f3b6bad183d66ff134e3b46500bd2502c9883efe99d3c7718bce2041daf9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dba26942feaad176d41a5a2fdc7e697e4f3d6f358daa211a7d6cb99cb6f3e330"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f74cb6d1ab130cd2a7a791d7020e115c83359deb7dea98bf3e363462765ac0c2"
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
