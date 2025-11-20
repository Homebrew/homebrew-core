class Dotslash < Formula
  desc "Simplified executable deployment"
  homepage "https://dotslash-cli.com"
  url "https://github.com/facebook/dotslash/archive/refs/tags/v0.5.8.tar.gz"
  sha256 "c80f7ce8b659c8f510659298ef5427bfaf7ee3258760bcffe2c45f7628de858e"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b64aa036b16b6fcf67b8e3001815f04a0d4ea4f8a061dc083f9f051200913a2e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d6f823160a3eaa74d901dda3b8cd6693f11456508edddd3cdea5aa82e83d7bef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "56f10dc0dd94c6b37c2c4da24d486e55bfbaad5521f50485954f79db37cb1307"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "52fd4aea162ac3759d9d9b4dd79684827756e874d5518133cf685f196b09417b"
    sha256 cellar: :any_skip_relocation, sonoma:        "44d37cda829fb1bbb60aa260a9681b0f571246be95ca6836c7242f4920a492d6"
    sha256 cellar: :any_skip_relocation, ventura:       "4f4b140144b5d0dc4695d856c0f56086f04ff00052a63dd30bc6f08cc06efa04"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "720fe95c2851a2bc7e3145e288dbe7d322a0a655beb9e1b102f7b94c0cfe10f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d09a00ba6f17535691be724216f47c4a2ffb7b012164a174690e01143590a119"
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
