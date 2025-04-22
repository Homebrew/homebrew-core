class Dotslash < Formula
  desc "Simplified executable deployment"
  homepage "https://dotslash-cli.com"
  url "https://github.com/facebook/dotslash/archive/refs/tags/v0.5.2.tar.gz"
  sha256 "4d459ddce4904c37b4c7a6cad8fd21833a9532c726839af1d1d28984623a77ab"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c3ac38a2e4a2cf63cfbd31d2d9cd2c4a38e684962ea47c4e2fef1ce68ddacb41"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3fc2f9e9270dd544592fb316fc64e78e78cec427a2db94623566fc28ce89a2fe"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fadffb4eaf0eaf8a3995778a8d17aecfae54d6fbeb81522937b64cc135f8a7f8"
    sha256 cellar: :any_skip_relocation, sonoma:        "74a6777b9f435596814d4787c64134387216428c6c580b4e47cd1f7aaf2145ee"
    sha256 cellar: :any_skip_relocation, ventura:       "33a908670fcb8199bb7cb40522cac0091f8a41e14a8cf0940e7dba839e3a31c5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dedd5aa3e2a4bd90a4d395f53206f0d6c69540b2bbc9a6f66939f8bf67776d49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d1d5fe8adf4e3778bf619e8e4961203106203e5a155cde245a0caee4351a8fb"
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
          "linux-aarch64": {
            "size": 44559104,
            "hash": "blake3",
            "digest": "bd605f5957f792def0885db18a9595202ba13f64d2e8d92514f95fb8c8ee5de5",
            "format": "tar.gz",
            "path": "node-v18.19.0-linux-arm64/bin/node",
            "providers": [
              {
                "url": "https://nodejs.org/dist/v18.19.0/node-v18.19.0-linux-arm64.tar.gz"
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
