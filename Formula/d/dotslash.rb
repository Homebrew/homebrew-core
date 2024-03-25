class Dotslash < Formula
  desc "Simplified executable deployment"
  homepage "https://dotslash-cli.com"
  url "https://github.com/facebook/dotslash/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "e1d55ecbe1a471a54a9f915df89faba23ff72fbfc5ad7b68e66f509b38bc8c9b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5678c69aaa638e05bae37dbee984b4ff51393ea41c913a554b7b5dc1e2f870a4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e35bf3f24552c0056243247c88f15c2825d188a17f34f4d3b974f764b3a7e044"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "30437ee711d5b0a2cd68da494df2bb84d95c86dfe9d5afca50ff80953405c5a0"
    sha256 cellar: :any_skip_relocation, sonoma:         "95c84aa6a85fa9224798953dbf7086d43e1e9ba46e56872ad79a2e268ccd1b39"
    sha256 cellar: :any_skip_relocation, ventura:        "8ed866b61a47651121e17e6c8932a24c9137b6f251744737cc3c807b4a18fb94"
    sha256 cellar: :any_skip_relocation, monterey:       "52ad3566e70c364723c78795e885d0a300ccf582b4c92879f0233ada9e9ae703"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc538e70942dbb1c3ea89059bc71b6e4ac0917fc5c15bac0f1326dc6d98d9a91"
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
