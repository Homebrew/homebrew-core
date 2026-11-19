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
    sha256 cellar: :any, arm64_golden_gate: "ebf70221da215f4f34a3bec2a1cb7e0fd331e277f610a9fdd06fd20a0cb9c2a3"
    sha256 cellar: :any, arm64_tahoe:       "3b0e0781fe460e2b2c44e3844da403b34baa731b53ae46f728c186d519d623fa"
    sha256 cellar: :any, arm64_sequoia:     "e80ba6a65ed2577c0a1c8e95a4310b31d50bdd523f9794853ea9f610610f8b7a"
    sha256 cellar: :any, arm64_linux:       "272e982099a8d0ba15aeb3c0c43b8fa2542af7e9b1d678dcb1ec2521182375ef"
    sha256 cellar: :any, x86_64_linux:      "637277a69c9ba49b1093ee044d10dc17a7b4ceb905266c7517517b67659d1d4e"
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
