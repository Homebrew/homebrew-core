class LivekitCli < Formula
  desc "Command-line interface to LiveKit"
  homepage "https://livekit.io"
  url "https://github.com/livekit/livekit-cli/archive/refs/tags/v2.20.1.tar.gz"
  sha256 "87ef9b068bda914e11bc942e670e74e3d129aadfcc3d01c543d8974c13923cfb"
  license "Apache-2.0"
  head "https://github.com/livekit/livekit-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    manifest_sha256 "fff84ddc47bb5091086bd6df605cc0de6fa6963f646ee686023062eb551b2644"
    sha256 cellar: :any, arm64_golden_gate: "30b6caf77c8cdc483fc1e4b2fe40e09b1de867a56279d1c36c668595db2a5a2b"
    sha256 cellar: :any, arm64_tahoe:       "dc21cc76c2320914b208b82ff180a4c5d6dbc6222d2287a3dfd5838b3e08864b"
    sha256 cellar: :any, arm64_sequoia:     "bdf435003b8cafbd4b977ea333761f0bd3a65ccb77b0c8064e13b16fffef7286"
    sha256 cellar: :any, arm64_linux:       "8107e7b83afb001cb733142ab3c4201cc17c026e6384ebd032809a9de8bec289"
    sha256 cellar: :any, x86_64_linux:      "637908f0a272cb486028bd314f4cdfe1e0cda07b255f2fbd1cf31fcbdeef8dee"
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
