class Dotslash < Formula
  desc "Simplified executable deployment"
  homepage "https://dotslash-cli.com"
  url "https://github.com/facebook/dotslash/archive/refs/tags/v0.5.4.tar.gz"
  sha256 "92e8f39796931436e122e6c57bfd49d2050eae07d800a920ce2bf52238c1ff02"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "91b6b4a9b932a4dd6cfbe44ac4d3ffc00a1e1e501cd806a5b97460687119ed3c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "45e7b52fd8f24163f285681fe6314ee0e660ebe99a7c42252a295b434ce9c55d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2e5a9805bffb4a46c1b2e587f17a116da53a2eae9c22ccb0d12dddaaa6394841"
    sha256 cellar: :any_skip_relocation, sonoma:        "bd36b90ae165d74df24b50f2bafbf0d3fb8ebf39921bbc81d4c844f9c7495da6"
    sha256 cellar: :any_skip_relocation, ventura:       "3da81ec9fc051eac5058dd6c75847a4f2257e9d48ee6671413381efcd88ed425"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8a2604418e667cca15f3408471e1e1061cd9572fde2414b5da461e46db2ccbf8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f6683eddc86a7a15762fa7f1a0b77cf630eb0a1d889783ecac448f743377ae5"
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
