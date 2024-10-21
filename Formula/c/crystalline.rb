class Crystalline < Formula
  desc "Language Server Protocol implementation for Crystal"
  homepage "https://github.com/elbywan/crystalline"
  url "https://github.com/elbywan/crystalline/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "45ed0162e724d2ef080e5264086bcea5b53d12fcafc5ddefc3bbf16af021fc48"
  license "MIT"

  bottle do
    sha256 arm64_sequoia: "58cb6766d9b3bde9205fc294459629e62cc7b0f33c8340d56541cbf8d58b7cf5"
    sha256 arm64_sonoma:  "d49db70364b4b5fffcd93c462c5522bbd0be7335b612ed59174866b1372f335f"
    sha256 arm64_ventura: "25ee4d95d2bf90dd2ebfd9dd3ad08e5d50c2435407e54324872d2e30f8f61d87"
    sha256 sonoma:        "2300f91fa3b8111f09e9749cf1fca4eeab71045765fedab5133081fb6ef9c52c"
    sha256 ventura:       "47a3caec8b5e43a8da8d246da2aeaa2c84a4735b572b3680eedaba931bed4796"
    sha256 x86_64_linux:  "715de9336f21432cd9d431bb5e7f4f280f9e5cef7947dccdb172b5dacab52ac4"
  end

  depends_on "bdw-gc"
  depends_on "crystal"
  depends_on "libevent"
  depends_on "libyaml"
  depends_on "llvm"
  depends_on "pcre2"

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

    output = pipe_output(bin/"crystalline", request, 0)
    assert_match "Content-Length", output
  end
end
