class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com/client_reference/"
  url "https://github.com/kosli-dev/cli/archive/refs/tags/v2.11.38.tar.gz"
  sha256 "a3eff9deadd0898320d318a8815ecea6266bda42101deb2b4507f7bc1118e334"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "364f0ae33b02587dc7abdb50255f4df76a248aa2a8a6272ca2397cfc60fa2906"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bb41bf15c33f63950540a43eb1bf8316986c6525ff6d335e2c2b5fa20fb166b1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ead1d392d728258ae65eb9eb7a06fdc7c8d230a6ab6e641aaed2432b7d9c5f1e"
    sha256 cellar: :any_skip_relocation, sonoma:        "c93da9def2e370f8f2216681ecff2d1056a2bed4b18315a1179e9cf20866de56"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f8ee626cfa9a53a40c47980f2a08a24c88e5d97d6fee90d830e54d6fded37a27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8ca7a2841ac100fea933b72c823776adb982009d60e726f626cb83d6da8eaab5"
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
