class LivekitCli < Formula
  desc "Command-line interface to LiveKit"
  homepage "https://livekit.io"
  url "https://github.com/livekit/livekit-cli/archive/refs/tags/v2.2.1.tar.gz"
  sha256 "b78bee20d70d190a43a65a1840e268aa2ac3661011cacb0717b235652b322e65"
  license "Apache-2.0"
  head "https://github.com/livekit/livekit-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4ef43d828cfc44303ce80d6075fa13a8170a13d31b9efbd8eb81e5553222eb53"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4ef43d828cfc44303ce80d6075fa13a8170a13d31b9efbd8eb81e5553222eb53"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4ef43d828cfc44303ce80d6075fa13a8170a13d31b9efbd8eb81e5553222eb53"
    sha256 cellar: :any_skip_relocation, sonoma:        "dcceac9d9ccec2f0b82895bf25ac4f96be2b311209594694d2d16a2e806afecd"
    sha256 cellar: :any_skip_relocation, ventura:       "dcceac9d9ccec2f0b82895bf25ac4f96be2b311209594694d2d16a2e806afecd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c4d030d2a870a1b6d77674b23bec5b2d94f92813c9dbce6d8fd7f824d01e9da2"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w"
    system "go", "build", *std_go_args(ldflags:, output: bin/"lk"), "./cmd/lk"

    bin.install_symlink "lk" => "livekit-cli"
  end

  test do
    output = shell_output("#{bin}/lk token create --list --api-key key --api-secret secret")
    assert output.start_with?("valid for (mins):  5")
    assert_match "lk version #{version}", shell_output("#{bin}/lk --version")
  end
end
