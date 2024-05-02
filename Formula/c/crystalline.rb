class Crystalline < Formula
  desc "Language Server Protocol implementation for Crystal"
  homepage "https://github.com/elbywan/crystalline"
  url "https://github.com/elbywan/crystalline/archive/refs/tags/v0.12.2.tar.gz"
  sha256 "32d137f1e4edd29c74381cc010e9080379346b23646ca5f0806f64d2e05628fb"
  license "MIT"
  revision 1

  bottle do
    sha256 arm64_sonoma:   "2e09bb98fe58a36d2d82b40297f903fbb9c98043d78a24f9fc540dbc3d2142d5"
    sha256 arm64_ventura:  "d18da6ae19f09ee3f27e1061dde820f088d7966c03fb834f2db8f8c610975309"
    sha256 arm64_monterey: "b3fb77d8bd6d93e0f7a26894a160bf133d32f0ebcd8d471efdeb211275281130"
    sha256 sonoma:         "ae194696b745eb4146a9ccf16a9b31b5256ed4ad2f15826b5172d87da172164e"
    sha256 ventura:        "d6435188e46125411a6842a38241dc01de32bb904513873474158e31464728f7"
    sha256 monterey:       "9be64a46e6a07bac61c078a9c64e51398f57c8838a81463ce8b255906bd37461"
    sha256 x86_64_linux:   "2136a41397a201535aef6400663111cb74eea320357ff178ffca1ad3396c291e"
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
