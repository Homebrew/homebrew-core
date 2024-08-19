class Crystalline < Formula
  desc "Language Server Protocol implementation for Crystal"
  homepage "https://github.com/elbywan/crystalline"
  url "https://github.com/elbywan/crystalline/archive/refs/tags/v0.13.1.tar.gz"
  sha256 "20e8cb266de5fd09db592846f695f30317792e923f2a2a4b03924e8ae97afd2e"
  license "MIT"

  bottle do
    sha256 arm64_sonoma:   "938ea9cbfd93bd3125a7a8cc33dbffee72c4a3da123046a0a062c01f30417cec"
    sha256 arm64_ventura:  "ba4e112f794bf5db29221fed0ed9cb707325edcd4811f0b93f9573f446adbe5f"
    sha256 arm64_monterey: "c1fec8db57b45f5e32bef38f4201ee372f0265a96fd09751c1276888b1036ce6"
    sha256 sonoma:         "67239639fbecbdbe632cc6828cbc96d055404891332a1d834b8c35f4a172dfb6"
    sha256 ventura:        "4429a7b544f4bafa107846d396beb6c2f38471296abad9ff0e708a9387f92cdd"
    sha256 monterey:       "d690f9519c1209784578d901db8ddb665ccf2a3cfd4d182332a20747a78ecdb0"
    sha256 x86_64_linux:   "61f2a2ec2189e4aaf9738b7d804b54996a27305395b02c53b8d90817a6e661c5"
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
