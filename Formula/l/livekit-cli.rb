class LivekitCli < Formula
  desc "Command-line interface to LiveKit"
  homepage "https://livekit.io"
  url "https://github.com/livekit/livekit-cli/archive/refs/tags/v2.18.0.tar.gz"
  sha256 "827990eb053a10bde94432894092b725f72658959a609cf607dea9c9898510dc"
  license "Apache-2.0"
  head "https://github.com/livekit/livekit-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "014083df45ec05c9f0beee61c37e905048db5b7db55ff70fdc506bf0178dfbd5"
    sha256 cellar: :any, arm64_sequoia: "a19640f7e8c11f364065c0722519802814c50596ed77dda4688de1df4caf7e3c"
    sha256 cellar: :any, arm64_sonoma:  "730d2ca26ba51b32c3ca1eee5194f16dce404f32f771a1af9c734687d49bdc3a"
    sha256 cellar: :any, sonoma:        "0db3ce46142abd302150cc4c104a4e3fb7d0adb97be92663b00b6187a045afec"
    sha256 cellar: :any, arm64_linux:   "31ac81f0dd88138af38ae6d961ca867ce24c1bea188295d534acbee0a37ed3f7"
    sha256 cellar: :any, x86_64_linux:  "3ea574015356c5a7b5de8204c86c8795e5919f5cef1d02bdb749dc1128f7393f"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build
  depends_on "portaudio"

  def install
    ENV["CGO_ENABLED"] = "1"
    ldflags = "-s -w"
    system "go", "build", *std_go_args(ldflags:, tags: "portaudio_system", output: bin/"lk"), "./cmd/lk"

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
