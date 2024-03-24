class Crystalline < Formula
  desc "Language Server Protocol implementation for Crystal"
  homepage "https://github.com/elbywan/crystalline"
  url "https://github.com/elbywan/crystalline/archive/refs/tags/v0.12.2.tar.gz"
  sha256 "32d137f1e4edd29c74381cc010e9080379346b23646ca5f0806f64d2e05628fb"
  license "MIT"
  revision 1

  bottle do
    sha256 arm64_sonoma:   "8b3a14b51496e54a12b6c05c9afb99c352b6db81b1063f56fb946e1c05500cf7"
    sha256 arm64_ventura:  "abba1c9b5837de3c4a170d4f0ac50770afc7b7b1b1b0e53cdd841e4f66bfed24"
    sha256 arm64_monterey: "3e0f71e345b2bcf1031d490c0390b262cfa8c75be25273820a1bee3288b22e1a"
    sha256 sonoma:         "90c4b784d95f277d7d7409dd5d2dd5d5756b69857f0165518edc4648579a9bad"
    sha256 ventura:        "0f9284cca91cd996884e8b7f83b23cac76f866a2c6d2036f7578587e6015c71a"
    sha256 monterey:       "ecd7f70f34d59c93fd7d1af673093ee3ecd39df5d5602918cbd62e000e0f8dd1"
    sha256 x86_64_linux:   "5c44c95d1c1a6528b0d5b64c04731ca91e41a8776c74b0381d0c99a5b340fd7b"
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
