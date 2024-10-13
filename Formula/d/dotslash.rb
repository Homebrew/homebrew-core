class Dotslash < Formula
  desc "Simplified executable deployment"
  homepage "https://dotslash-cli.com"
  url "https://github.com/facebook/dotslash/archive/refs/tags/v0.4.2.tar.gz"
  sha256 "5d54dce858e306b201e1023d9b3d884355b22b1c2f920d98f957f64993eaa44e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d5a052a95ff14495b80fae7f1169ab8dc8642812ca22412ca610f71ab0f3b301"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "036d5d79578e244d1773dcc76932172ad245e781e72f3f19f2f79e5be4cb94fc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "07ac4ff140abce52f4190acdf5a2a94f57df7f739d9fd15243297f0cefa94196"
    sha256 cellar: :any_skip_relocation, sonoma:        "761844c0cf5a845c1f6d56b8707bc8b8414d33c6e2aa8149cf32030183e022cf"
    sha256 cellar: :any_skip_relocation, ventura:       "d9e99219a44e170e40e4a22b4babc306e53d22e5fede5514973eb2e975376eb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b87d109c40065d9281f2dad425b38adbb84f3fd2d8d067e4b4c5094121febcd0"
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
