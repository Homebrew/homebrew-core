class Dotslash < Formula
  desc "Simplified executable deployment"
  homepage "https://dotslash-cli.com"
  url "https://github.com/facebook/dotslash/archive/refs/tags/v0.4.3.tar.gz"
  sha256 "88c599392a6135208935889ecbefaafe8d5fc12e08baadb4d83658247501eb5b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "015492727f9c99f567dc69252b0bb86ccebec14c6cd036626c82a292a04545d4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "03ececb48fa448a9a5fb839df4134d57679502db5ae82ec37d4a0ecd60194b66"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c43d5403b8b3597e224031465cc3873c95a8ee26b14c209fcb7bf509ccf141cb"
    sha256 cellar: :any_skip_relocation, sonoma:        "fae55211639f161f387252c223a25c853ad4bdee836d676b823a4670205331cf"
    sha256 cellar: :any_skip_relocation, ventura:       "af6b2e1b6615bd14e05c8be41abf947c9ba02d6417e3a7f9750f848fb0b5630e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "59d69ed4f0ba3c8363193ec7042184ce85b86445ec68fd10aa18acf76928e295"
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
