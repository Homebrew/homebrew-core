class LivekitCli < Formula
  desc "Command-line interface to LiveKit"
  homepage "https://livekit.io"
  url "https://github.com/livekit/livekit-cli/archive/refs/tags/v2.20.0.tar.gz"
  sha256 "f3f446496d49c4d78d58fcb7184571a36c81e2fbb3e36cc0c357e7f73255fead"
  license "Apache-2.0"
  head "https://github.com/livekit/livekit-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "4ac5a9cc021b25e3450c310cc3e15fc71095f9e8ad9d483d9ea3bfcce003138d"
    sha256 cellar: :any, arm64_tahoe:       "8e396414f838a04d337663783a9df44e70ad44f9d9262c94fe0a52cf0c318ea4"
    sha256 cellar: :any, arm64_sequoia:     "06473420a36c7257961c3553d3ccd5adea913a21e5dc72f7ebad758f2537e627"
    sha256 cellar: :any, arm64_linux:       "405aa68fff03d29c7175c194215635e7d64b5fcdd16293707a7f0d360f3bc388"
    sha256 cellar: :any, x86_64_linux:      "9a219ebfae3e5326217cc480bd842166e68a685e03216263b9f010f92d67e069"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build
  depends_on "portaudio"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "1"
    system "go", "build", *std_go_args(tags: "portaudio_system", output: bin/"lk"), "./cmd/lk"

    bin.install_symlink "lk" => "livekit-cli"

    bash_completion.install "autocomplete/bash_autocomplete" => "lk"
    zsh_completion.install "autocomplete/zsh_autocomplete" => "_lk"
    generate_completions_from_executable(bin/"lk", "generate-fish-completion",
                                         shell_parameter_format: :none, shells: [:fish])
  end

  test do
    output = shell_output("#{bin}/lk token create --list --api-key key --api-secret secret 2>&1")
    assert_match "valid for (mins): 5", output
    assert_match "lk version #{version}", shell_output("#{bin}/lk --version")
  end
end
