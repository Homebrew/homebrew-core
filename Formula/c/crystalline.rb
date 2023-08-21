class Crystalline < Formula
  desc "Language Server Protocol implementation for Crystal"
  homepage "https://github.com/elbywan/crystalline"
  url "https://github.com/elbywan/crystalline/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "26c926ba423e4b04fc52af501cd842c8255312014fc4aa1bc3735a8cd0df3426"
  license "MIT"

  bottle do
    sha256 arm64_ventura:  "3cb46e330dab39dad7f95b9bcb62e5cc059a5e223f8f0bbce3ebe1f78447b03f"
    sha256 arm64_monterey: "52ec44a201cf107c54393203771380e931e85f1a842e2c35f69325f19b3003fe"
    sha256 arm64_big_sur:  "baa787f5f7ec0d5503d34740c0b487f9c9202933d652c2d6a2cf834e2352d830"
    sha256 ventura:        "ebb043ac152b8423a005281c4c479dfbc52cf14bca9603cc9a50cc59973925d7"
    sha256 monterey:       "b62edecae1746cbc0824d08420bece5f42c703786e4240dd508c08e3d7d37d4d"
    sha256 big_sur:        "b0398dcc4e016063f67cb5408c44a858061d735784015997e9715ba0495428fb"
    sha256 x86_64_linux:   "4408fa4fb3a5df0272e21344d5b60656f1b14175b4c37c7b0ca5e067bf903369"
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
