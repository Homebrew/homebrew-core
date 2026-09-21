class LivekitCli < Formula
  desc "Command-line interface to LiveKit"
  homepage "https://livekit.io"
  url "https://github.com/livekit/livekit-cli/archive/refs/tags/v2.18.7.tar.gz"
  sha256 "ed0d2168bf4784f3b5b987d7499128f7de95c276d7aa4514aa8a872b820d6e99"
  license "Apache-2.0"
  head "https://github.com/livekit/livekit-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "1b1d628796d6c22351d151f3f9bb8f22f3773f297175f6f22c215e2ca419d921"
    sha256 cellar: :any, arm64_tahoe:       "6fd62df8755f3bee8aa859229781244a559225ef8863399546dcd7d583126069"
    sha256 cellar: :any, arm64_sequoia:     "a7f520e14295996e0a93ad1cd59cee3a756fe1aa127fdfeac2f3530663e77734"
    sha256 cellar: :any, arm64_linux:       "0b3acf3fe7dc1ea482f4c1f9cb2ce9151dad7cf07d29d330258586477a681cd1"
    sha256 cellar: :any, x86_64_linux:      "c623e99ffa3b1087fa05656ad24281ba0aa46af325e3ad1aec15b74657bc71d4"
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
    fish_completion.install "autocomplete/fish_autocomplete" => "lk.fish"
    zsh_completion.install "autocomplete/zsh_autocomplete" => "_lk"
  end

  test do
    output = shell_output("#{bin}/lk token create --list --api-key key --api-secret secret 2>&1")
    assert_match "valid for (mins): 5", output
    assert_match "lk version #{version}", shell_output("#{bin}/lk --version")
  end
end
