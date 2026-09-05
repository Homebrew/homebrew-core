class LivekitCli < Formula
  desc "Command-line interface to LiveKit"
  homepage "https://livekit.io"
  url "https://github.com/livekit/livekit-cli/archive/refs/tags/v2.18.6.tar.gz"
  sha256 "1e09cc20149ab26ff505f7893cd86eddfe0db246dd14f175beab38e3dd6b4bc5"
  license "Apache-2.0"
  head "https://github.com/livekit/livekit-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "46d154410a47a2985a73a9eed1fa7e7246f60a4f94b5e1647c7285978c685d35"
    sha256 cellar: :any, arm64_sequoia: "d8b0805e60fbe881e7e09cf6b361ca07cc1f87ef4e41b2dee334c37b3ea38e28"
    sha256 cellar: :any, arm64_sonoma:  "eba0a6d5b8adf9f00ff724841e9bfa5850df5daccdf3be2e8a2e933b324ab58b"
    sha256 cellar: :any, arm64_linux:   "2f27d6848e9934f463493d87496662fe1790b79b053fc64559fa9e4117d8b3d2"
    sha256 cellar: :any, x86_64_linux:  "b653a0c770865ea5a3850eea4278e0a1f52d90b99e804039f580f0f55b96007f"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build
  depends_on "portaudio"

  def install
    ENV["CGO_ENABLED"] = "1"
    system "go", "build", *std_go_args(tags: "portaudio_system", output: bin/"lk"), "./cmd/lk"

    bin.install_symlink "lk" => "livekit-cli"

    bash_completion.install "autocomplete/bash_autocomplete" => "lk"
    fish_completion.install "autocomplete/fish_autocomplete" => "lk.fish"
    zsh_completion.install "autocomplete/zsh_autocomplete" => "_lk"
  end

  test do
    output = shell_output("#{bin}/lk token create --list --api-key key --api-secret secret 2>&1")
    assert_match "valid for (mins): 5", output
    assert_match "lk version #{version}", shell_output("#{bin}/lk --version")
  end
end
