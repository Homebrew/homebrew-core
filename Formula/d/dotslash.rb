class Dotslash < Formula
  desc "Simplified executable deployment"
  homepage "https://dotslash-cli.com"
  url "https://github.com/facebook/dotslash/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "e1d55ecbe1a471a54a9f915df89faba23ff72fbfc5ad7b68e66f509b38bc8c9b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bf3a2a90ba611d8ba9a80845aeb2fd2c74bdaae8d0e3a583bacbcb5f06f7e142"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9aab2ff43179d9f2a4400cc292fd7f9109eb4a75ceba009e877ed5dff381c865"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bdd359772064f0c4c7b9fe88a89fcce4b2e65b537b84913ac3a2fa5085799e79"
    sha256 cellar: :any_skip_relocation, sonoma:         "813dabfbc78ffb2c730b6027f2bd4df47906e4e0a5c3df18d2fb85a440b2d181"
    sha256 cellar: :any_skip_relocation, ventura:        "a304ec04b729c20a5a46fdd44d403a25ebfb7cf43e5b04c3c4d88a0b7dd0424d"
    sha256 cellar: :any_skip_relocation, monterey:       "5838717bd257244a1ad33e096f0fce5e4c5d431e58b76b505389ce4c22b7bf48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4fcfa3a61536c198241b748fbff8a07527a5d27597e03a502846fd6c100c53e4"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"node").write <<~EOS
      #!/usr/bin/env dotslash

      // Example file from https://dotslash-cli.com/docs/.
      // The URLs in this file were taken from https://nodejs.org/dist/v18.19.0/

      {
        "name": "node-v18.19.0",
        "platforms": {
          "macos-aarch64": {
            "size": 40660307,
            "hash": "blake3",
            "digest": "6e2ca33951e586e7670016dd9e503d028454bf9249d5ff556347c3d98c347c34",
            "format": "tar.gz",
            "path": "node-v18.19.0-darwin-arm64/bin/node",
            "providers": [
              {
                "url": "https://nodejs.org/dist/v18.19.0/node-v18.19.0-darwin-arm64.tar.gz"
              }
            ]
          },
          "macos-x86_64": {
            "size": 42202872,
            "hash": "blake3",
            "digest": "37521058114e7f71e0de3fe8042c8fa7908305e9115488c6c29b514f9cd2a24c",
            "format": "tar.gz",
            "path": "node-v18.19.0-darwin-x64/bin/node",
            "providers": [
              {
                "url": "https://nodejs.org/dist/v18.19.0/node-v18.19.0-darwin-x64.tar.gz"
              }
            ]
          },
          "linux-x86_64": {
            "size": 44694523,
            "hash": "blake3",
            "digest": "72b81fc3a30b7bedc1a09a3fafc4478a1b02e5ebf0ad04ea15d23b3e9dc89212",
            "format": "tar.gz",
            "path": "node-v18.19.0-linux-x64/bin/node",
            "providers": [
              {
                "url": "https://nodejs.org/dist/v18.19.0/node-v18.19.0-linux-x64.tar.gz"
              }
            ]
          }
        }
      }
    EOS
    chmod 0755, testpath/"node"
    assert_match "v18.19.0", shell_output("#{testpath}/node -v")
  end
end
