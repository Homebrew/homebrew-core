class Crystalline < Formula
  desc "Language Server Protocol implementation for Crystal"
  homepage "https://github.com/elbywan/crystalline"
  url "https://github.com/elbywan/crystalline/archive/refs/tags/v0.16.0.tar.gz"
  sha256 "4639607061f8d137d2dd1a66cfa673052930d628ef9da7f65f8cab70c615e6e1"
  license "MIT"
  revision 1

  bottle do
    sha256 arm64_sequoia: "74fc5292101479244145e18298486ffa42ed84f6ee5bc7b38efbd763ca133269"
    sha256 arm64_sonoma:  "0f6cc0d9b7d82e8af4143614e4716c54e729485be785d052931ec427d83512e9"
    sha256 arm64_ventura: "7f33ffa5bf67a6a63ac70dd81696c8d2db6a13d99a8ca0db59096ade9f22218e"
    sha256 sonoma:        "42a06924a2a7dc079ee41705e5c2f9c0728ca08114896213e130c6d9bd749dff"
    sha256 ventura:       "6614f83c5e7f5ef22bc78e2367e1353b7936242e1d8418add0fcbf2bb8cda7e8"
    sha256 x86_64_linux:  "069fd5b2879f927e51065aa2ada16019db9dd527d63e837a5927e65d25105d87"
  end

  depends_on "bdw-gc"
  depends_on "crystal"
  depends_on "libevent"
  depends_on "libyaml"
  depends_on "llvm@19"
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
    payload = <<~JSON
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
    JSON

    request = <<~LSP_REQUEST
      Content-Length: #{payload.size}

      #{payload}
    LSP_REQUEST

    output = pipe_output(bin/"crystalline", request, 0)
    assert_match "Content-Length", output
  end
end
