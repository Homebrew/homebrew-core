class LivekitCli < Formula
  desc "Command-line interface to LiveKit"
  homepage "https://livekit.io"
  url "https://github.com/livekit/livekit-cli/archive/refs/tags/v2.16.0.tar.gz"
  sha256 "70f2f6cab71423a29228d103b24d66dccbde9fb8e2beef060b4467ac03f5eabc"
  license "Apache-2.0"
  head "https://github.com/livekit/livekit-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "261790fc2e70e56dcfa61a64e8a0f9ac4f6e2c568af40fb18637f04b840c2c25"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ec42380d7334c64b2ea27be4d5d6c22a6db344861f28774ac5b2569faffae723"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aca0b204ef8676237701a7d6614bbbe2c8590e13ded298f6bf764894c4b89ab2"
    sha256 cellar: :any_skip_relocation, sonoma:        "f58559ff48914ed8f9de4b3f3c1dae90c9215b868636d082f6fe171c10e6fc68"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5b3ebfad34ab04545b20e1bd6e732218c7b1435c9964a54e30f3bc81d173d9be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b30d59d5fde9d35968c62e4f583eeb11c3bb041d21d96280d66c60b326bdb745"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w"
    system "go", "build", *std_go_args(ldflags:, output: bin/"lk"), "./cmd/lk"

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
