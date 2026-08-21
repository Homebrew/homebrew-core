class Crystalline < Formula
  desc "Language Server Protocol implementation for Crystal"
  homepage "https://github.com/elbywan/crystalline"
  url "https://github.com/elbywan/crystalline/archive/refs/tags/v0.19.0.tar.gz"
  sha256 "7cab91e23bf2e7d87ab3e63c60a555507a00da709af1fad5fe55de44dadea71a"
  license "MIT"
  revision 1

  bottle do
    sha256 arm64_tahoe:   "f07c7d13ef5fdf413d9258e4a4c421163c8a821c7853d7c03ad15f34c4b28af5"
    sha256 arm64_sequoia: "77134e5b99a0c697210112504b1e499313858cc3c4ce6ad34ccd186577b16652"
    sha256 arm64_sonoma:  "1dd71e2bfe371c7af0f60db6932fa708bbfec066de4220695f44529e207e5d69"
    sha256 sonoma:        "005a9d70afbd4d50f30a92594270775dd0e44648b6b4c514ef3222ea7807dd4b"
    sha256 arm64_linux:   "1a8246f537582e818bd14d55345edbd691605d83fd6dc79fb1b3cd165455484c"
    sha256 x86_64_linux:  "c469a271f9fb95142f7bd22971e3f0785f088af26b6d9134e7516c6262ecc418"
  end

  depends_on "bdw-gc"
  depends_on "crystal"
  depends_on "libevent"
  depends_on "libyaml"
  depends_on "llvm@22"
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
