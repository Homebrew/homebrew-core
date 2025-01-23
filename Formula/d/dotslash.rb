class Dotslash < Formula
  desc "Simplified executable deployment"
  homepage "https://dotslash-cli.com"
  url "https://github.com/facebook/dotslash/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "4498ee0cb369d2678962384d1777650d1e1446dba730740882e5d2f06f0a667a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8dd44a76f36d0b62396641acc690ef41aa814137ca06ee9485a5f1b8a7d7d3e9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9532370edb7745aff8c37e0770b65111f69443542e0642a8136ccd43193540d3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "013e2763c9c3f64943efb8b4212ac55547b9dd227121ea90516d774d3ee81fcb"
    sha256 cellar: :any_skip_relocation, sonoma:        "799650645a653f2701522970c7944dadf4f4f2705288083ff3cac6e8cfa093eb"
    sha256 cellar: :any_skip_relocation, ventura:       "ee8b837f39a5e25cb1343691c7d65526265377430c7488b058db2ca6ead01f91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5c51683c122a28b504aac71e703234a453bb72e9767e36c7d9fc7f84eb821b24"
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
