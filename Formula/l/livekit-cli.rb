class LivekitCli < Formula
  desc "Command-line interface to LiveKit"
  homepage "https://livekit.io"
  url "https://github.com/livekit/livekit-cli/archive/refs/tags/v2.4.10.tar.gz"
  sha256 "bdf281ceac61ad60908929f3c53f040312dccad594b22f4a4613fb0300f56db4"
  license "Apache-2.0"
  head "https://github.com/livekit/livekit-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "948940571c1baa54d498c7452298f9d159910014dcc0a4265211baf47178deee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "948940571c1baa54d498c7452298f9d159910014dcc0a4265211baf47178deee"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "948940571c1baa54d498c7452298f9d159910014dcc0a4265211baf47178deee"
    sha256 cellar: :any_skip_relocation, sonoma:        "bdf6dd1e3a19a3f9e336eb9927c364095329c71fe0447080ba920f8ea2d8c62f"
    sha256 cellar: :any_skip_relocation, ventura:       "bdf6dd1e3a19a3f9e336eb9927c364095329c71fe0447080ba920f8ea2d8c62f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e29fc66f0af3a6dd14801816c92512fbf7d99aa474013bf2531c166bc674e4a7"
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
    assert output.start_with?("valid for (mins):  5")
    assert_match "lk version #{version}", shell_output("#{bin}/lk --version")
  end
end
