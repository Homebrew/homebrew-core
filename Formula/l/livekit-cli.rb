class LivekitCli < Formula
  desc "Command-line interface to LiveKit"
  homepage "https://livekit.io"
  url "https://github.com/livekit/livekit-cli/archive/refs/tags/v2.4.5.tar.gz"
  sha256 "becf1ef8134196d2b3da960654732619822bd2f232a502d913eba7269879b4a5"
  license "Apache-2.0"
  head "https://github.com/livekit/livekit-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c26105a8fee42a467eea63aa60994794ef8c34bd4d259d1ce4c7773799e05861"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c26105a8fee42a467eea63aa60994794ef8c34bd4d259d1ce4c7773799e05861"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c26105a8fee42a467eea63aa60994794ef8c34bd4d259d1ce4c7773799e05861"
    sha256 cellar: :any_skip_relocation, sonoma:        "79e4f6619ca7fd03cb1bb807c0363a4703780c084eda3adb0f963fb6850a4fc4"
    sha256 cellar: :any_skip_relocation, ventura:       "79e4f6619ca7fd03cb1bb807c0363a4703780c084eda3adb0f963fb6850a4fc4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "373c9736365ddf84fb0f768defe16b160445919f83b7ec4162ac9669e5c668d1"
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
