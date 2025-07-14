class LivekitCli < Formula
  desc "Command-line interface to LiveKit"
  homepage "https://livekit.io"
  url "https://github.com/livekit/livekit-cli/archive/refs/tags/v2.4.13.tar.gz"
  sha256 "23d4f6f8d14966782402f53020e1efe95c17dba2ffacdc45a76548b51fff571b"
  license "Apache-2.0"
  head "https://github.com/livekit/livekit-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2f4f1ed1a4c3bba188ac1258c8197ce3d9acf7e4e3ae8db2d40829204d1b521e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cfa03ab451d40326d2e95ba414116e420d9df7bccae5c7f59eea69b0f4ce8965"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9bb8414bf923e5c6d049e0a1d6fc66784652a86b90dc79dd51edf22aa3dbfaac"
    sha256 cellar: :any_skip_relocation, sonoma:        "02886bcb059cd7d97a62d49719da348e296db2819989a196a59f579a5e1c552f"
    sha256 cellar: :any_skip_relocation, ventura:       "6e083c424a352de67f8f8f49d9b194d2ab29c00d927918b0b2cd9928c5d06f6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4defa4b13244ffec163c6a08621a539ec979188afb4682feafde2c9313f3d11e"
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
    output = shell_output("#{bin}/lk token create --list --api-key key --api-secret secret")
    assert_match "valid for (mins):  5", output
    assert_match "lk version #{version}", shell_output("#{bin}/lk --version")
  end
end
