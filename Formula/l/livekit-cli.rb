class LivekitCli < Formula
  desc "Command-line interface to LiveKit"
  homepage "https://livekit.io"
  url "https://github.com/livekit/livekit-cli/archive/refs/tags/v2.19.3.tar.gz"
  sha256 "482a93567afc4b788ece62809b8b2791412cf4e8bdb10657945793a5360d234a"
  license "Apache-2.0"
  head "https://github.com/livekit/livekit-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "cc3709f2b24c1ea41ee01ef558150b569d3adf3fe01429e9a80f1c0c92c6370d"
    sha256 cellar: :any, arm64_tahoe:       "7bacab4383bcc5126127bf8ddac0daa1cad3dd131f6163474ae478e5773aadbd"
    sha256 cellar: :any, arm64_sequoia:     "432200f13a97aad29bb2e9c208272ceddb2d3efd2967b3a34e434ca1556d87cb"
    sha256 cellar: :any, arm64_linux:       "9e1395eed0d3db97d574bf80b5c30d2430c2f2f655aa59a9bbc4e9c0a00ec082"
    sha256 cellar: :any, x86_64_linux:      "53fff5174ccfff81b688df219e937059e2e0ff3f2d885091e974e947c1fc1f6d"
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
