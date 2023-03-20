class LivekitCli < Formula
  desc "Command-line interface to LiveKit"
  homepage "https://livekit.io"
  url "https://github.com/livekit/livekit-cli/archive/refs/tags/v1.2.3.tar.gz"
  sha256 "323025a028c3e57bdef4d39c10d3b49af8ab7a8b1858c7c946d1ec771939414e"
  license "Apache-2.0"
  head "https://github.com/livekit/livekit-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a286827d53f2b93fb6d7319bb41efb8056fc8c2e06617e8c58f866a3df248090"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "910117fd3c6d4d125dd3dfe1a02ef159caa072fc3bac8c60bb0cc3fe6ae8dc20"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2a3a4d1fca109c1885f230a7ccadcc4b66596e9f6e28b99e93c6fe2c430d5f9f"
    sha256 cellar: :any_skip_relocation, ventura:        "eb427e90cb56bb5ced73879ad12d269f6551a745b71684aae5ab2a8982a279b0"
    sha256 cellar: :any_skip_relocation, monterey:       "db1adea91044443d434dc5c56ba6e08b0e70e0fe2525b81e7ffc003b7d2b5ae7"
    sha256 cellar: :any_skip_relocation, big_sur:        "ad23818350c425165c1b5e1b08c2682bf39228ac97ebc34f427b42204a5b85c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b9eec26eee7c83ed9719d7554dc4258db7b40a1b497d7264a7882e88656b3351"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/livekit-cli"
  end

  test do
    output = shell_output("#{bin}/livekit-cli create-token --list --api-key key --api-secret secret")
    assert output.start_with?("valid for (mins):  5")
    assert_match "livekit-cli version #{version}", shell_output("#{bin}/livekit-cli --version")
  end
end
