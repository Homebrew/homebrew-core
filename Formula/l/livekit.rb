class Livekit < Formula
  desc "Scalable, high-performance WebRTC server"
  homepage "https://livekit.io"
  url "https://github.com/livekit/livekit/archive/refs/tags/v1.13.5.tar.gz"
  sha256 "50633b65316b0b8c854fb4bee4ae4040839fcf5c149bccb9ae2097fb7526991c"
  license "Apache-2.0"
  head "https://github.com/livekit/livekit.git", branch: "master"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0c9c6445e34a96fc883a4ec05905426aa8fb2d9094e5a776fe2c2575b8dcbae8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0f06289bb7d7ebd6196b914e17c114ccf304781e773910fb403e1b0f42e66741"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "951271e9838d6c9cf01769e722243cbe13667e0c1be2cc57a4063b5645eb1b30"
    sha256 cellar: :any_skip_relocation, sonoma:        "cd59566b4581304f6611b4e74c8bba1db844bc35ed8b292eae5b061321dc9994"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "69d25a6f90f12b87653570f3ecad3307f772a924f21e17165cecd7d746bda215"
    sha256 cellar: :any,                 x86_64_linux:  "ddede970500facb614bde73bfc6160ad2814f0f581ac7e42ffc619a6d0237383"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"livekit-server"), "./cmd/server"
  end

  test do
    http_port = free_port
    random_key = "R4AA2dwX3FrMbyY@My3X&Hsmz7W)LuQy"
    spawn bin/"livekit-server", "--keys", "test: #{random_key}", "--config-body", "port: #{http_port}"
    sleep 3
    assert_match "OK", shell_output("curl -s http://localhost:#{http_port}")

    output = shell_output("#{bin}/livekit-server --version")
    assert_match "livekit-server version #{version}", output
  end
end
