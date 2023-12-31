class Crystalline < Formula
  desc "Language Server Protocol implementation for Crystal"
  homepage "https://github.com/elbywan/crystalline"
  url "https://github.com/elbywan/crystalline/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "488449ea0612034e6d4c9afac4c4bdac80111ea79dd6212d530ddf47f8d813f7"
  license "MIT"
  revision 1

  bottle do
    sha256 arm64_sonoma:   "94ae7d480b3f8d0eed2874c1e43c89c4e1e8651b6a953606d68e424d3a276c82"
    sha256 arm64_ventura:  "aeeb0994d3460fe2fd701d4838b19a22b8d9573300d0e41f931661f30c9af2ea"
    sha256 arm64_monterey: "0fa83f1c2cf6fc2955e1d42d543f926df7a82071a6226466f28e8e95a5eba646"
    sha256 sonoma:         "fb9d864173a387f76666ebf362d1969386bf4b429c93676b7015e74a461efac9"
    sha256 ventura:        "d58bda1989af82ee86fcaba7e38da17b66cb538bb0887c1518ac3f097ea3e41f"
    sha256 monterey:       "dd4a5faabefe4bb28e0803a5dd31fa210ae005a5283e70c0218e5c6f45b76352"
    sha256 x86_64_linux:   "d124ae8ed4ee790007c35c116c4c4ea299c8a1121849bc0779739c8dddd89924"
  end

  depends_on "crystal"
  depends_on "libyaml"

  def install
    system "shards", "install"
    system "crystal", "build", "./src/crystalline.cr",
      "--release", "--no-debug",
      "-Dpreview_mt",
      "--progress", "--stats", "--time",
      "-o", "crystalline"

    bin.install "crystalline"
  end

  test do
    payload = <<~LSP_PAYLOAD
      {
        "jsonrpc": "2.0",
        "id": 1,
        "method": "initialize",
        "params": {
          "processId": 88075,
          "rootUri": null,
          "capabilities": {},
          "trace": "verbose",
          "workspaceFolders": null
        }
      }
    LSP_PAYLOAD

    request = <<~LSP_REQUEST
      Content-Length: #{payload.size}

      #{payload}
    LSP_REQUEST

    output = pipe_output("#{bin}/crystalline", request, 0)
    assert_match "Content-Length", output
  end
end
