class LivekitCli < Formula
  desc "Command-line interface to LiveKit"
  homepage "https://livekit.io"
  url "https://github.com/livekit/livekit-cli/archive/refs/tags/v2.3.1.tar.gz"
  sha256 "e6e6bf11930e47356248fd1b7e90549692ee415a77caf8f9d8b15ae471a31420"
  license "Apache-2.0"
  head "https://github.com/livekit/livekit-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bda9df0c2e63f78d7db9d5112a30434a50ad04701408624d04c765500d07f0be"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bda9df0c2e63f78d7db9d5112a30434a50ad04701408624d04c765500d07f0be"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bda9df0c2e63f78d7db9d5112a30434a50ad04701408624d04c765500d07f0be"
    sha256 cellar: :any_skip_relocation, sonoma:        "b3c87745f07681b3c1aa89d5602d1838a5bdfec611ec0b4cff1450418b7c90e9"
    sha256 cellar: :any_skip_relocation, ventura:       "b3c87745f07681b3c1aa89d5602d1838a5bdfec611ec0b4cff1450418b7c90e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a0f789d9dd73230cab3f057257607deb6e50dd2a66482e6e851e1212576013d8"
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
