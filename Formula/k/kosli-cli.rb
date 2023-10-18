class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com/client_reference/"
  url "https://github.com/kosli-dev/cli/archive/refs/tags/v2.6.11.tar.gz"
  sha256 "780c58a594ae8a2a4f99d4fb808bb8c8bdfa64c0112702b993140d28445c37cb"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8664af20f61da7420d817f66bd25e70c238524e7ca3ac7815422542a28a0fa5e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a0b45443d40aa64b4de3600b6375489383872e55a10be689ef782fa7d6c9850a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d890a911bf66cbb628614717449f906ab329f85e3342e45fe4c76347e3c759ef"
    sha256 cellar: :any_skip_relocation, sonoma:         "1c793a4bb97f5a1096f7fbab20f06e60d12e8d20f73e2a530295c24cc61a4ad9"
    sha256 cellar: :any_skip_relocation, ventura:        "af6d1598d02a7d31505e527810d956781bb93ee4d1bae1888e6309e9df2aacbc"
    sha256 cellar: :any_skip_relocation, monterey:       "786e77151ae343d9d651fab28cd2fcf402b72dcf1e007308b7668d8846a6eacc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7dd92d24a9a2597008c57d80d711b40a41d4829f737e65397f2cbb622c762967"
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
