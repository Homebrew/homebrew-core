class Dotslash < Formula
  desc "Simplified executable deployment"
  homepage "https://dotslash-cli.com"
  url "https://github.com/facebook/dotslash/archive/refs/tags/v0.5.7.tar.gz"
  sha256 "6241825e7f325a958cd1ac3e541a6974a5c0718e63d6172fd5898cc8a64fea2e"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "708b7227122f3d87b2c005e5e08d96e8f8762a32588f348078be128816bc399f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "937ee205c5e6e349ccfe5ba1e60ff38beafed9efe0fd4e48f4ffc793be7095e7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e4c213aa8ce6c5d0b031ca1aa2a18e54017a9c98926a0a5a9ae8e3af1f756f66"
    sha256 cellar: :any_skip_relocation, sonoma:        "8da318115de7e09da26c1687b656a2b514fe9173ed95d48321fa54969cea16db"
    sha256 cellar: :any_skip_relocation, ventura:       "73c7e38ad2e42686e1f22fed9d798b31b371b96ebc1661cbd573d08e16408469"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d539bdb30c991eb62f6db97e57f496445d3b8c56f6c9ac2c2eac63740130269e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "12083e62c4c2f6fb88d4d266396a2cc00369cbdcb5c3e0110b847f94bebda116"
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
