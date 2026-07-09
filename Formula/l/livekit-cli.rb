class LivekitCli < Formula
  desc "Command-line interface to LiveKit"
  homepage "https://livekit.io"
  url "https://github.com/livekit/livekit-cli/archive/refs/tags/v2.17.0.tar.gz"
  sha256 "0bdaa6198445e3cef020ebc8cac10db8a849e488832692670a2434c9750761fc"
  license "Apache-2.0"
  head "https://github.com/livekit/livekit-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "0adcf0c278e06906f53b8225272e5ec52f48ad122afdc548ebe6759ccf7db076"
    sha256 cellar: :any, arm64_sequoia: "2250aaec4fe635bfd22c57db232d7ec2dc7ebdd3738d6503babae6b4ed97e14f"
    sha256 cellar: :any, arm64_sonoma:  "6c5759e00e622c77e9a8c53584e4c6a65ffafbf4a5779354efd1bc7a3e04834e"
    sha256 cellar: :any, sonoma:        "c7b4b52c30b3aabcbe3c2695839bd8ec112d4a0380fbb9b6c14ef7f443fd9f41"
    sha256 cellar: :any, arm64_linux:   "718e6014d5728860bcc8e5df20d8dc39fa6e48db064dd8557ea7ee35aea7d8bf"
    sha256 cellar: :any, x86_64_linux:  "1c34984c6419dcf7494e818a7d1cf3e9f830fdd0b98b7ebe831e8a135953db34"
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
