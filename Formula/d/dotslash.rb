class Dotslash < Formula
  desc "Simplified executable deployment"
  homepage "https://dotslash-cli.com"
  url "https://github.com/facebook/dotslash/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "c8d24060cc0a4ec374ea519133948b2229f0aca6e696fdfc330601d9d9cd5509"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "abdc5444e29cba9375fbd7dcbe0dcb069b95e47713e35213616234ef06546a1e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3fe6efea846dc59ab6b4a983973c96a22716dfa5c1bffe2ae30a057bdf8f25c9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "005875e648b741696d0b17af99025601611f5a1b8f9b3d038f895ece8c526a89"
    sha256 cellar: :any_skip_relocation, sonoma:         "9b22ea5b788b847f265fda1d3593f465c9253003b3faf9809c2a0a7405e0eb8c"
    sha256 cellar: :any_skip_relocation, ventura:        "83189285d8bc1effcdb2c0334542d330f07aa8eb855c1466bafcd79bda3c0ab3"
    sha256 cellar: :any_skip_relocation, monterey:       "6a583dd97913e89300b70c4a3db2b76ce067bb4036fee74a29b4c8eccaca2bb7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e766a6a3983265120f56f11a997e0757d5a207fa49a30e611ce8111243f4d76c"
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
