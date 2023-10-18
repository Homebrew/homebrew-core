class Crystalline < Formula
  desc "Language Server Protocol implementation for Crystal"
  homepage "https://github.com/elbywan/crystalline"
  url "https://github.com/elbywan/crystalline/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "488449ea0612034e6d4c9afac4c4bdac80111ea79dd6212d530ddf47f8d813f7"
  license "MIT"

  bottle do
    sha256 arm64_sonoma:   "2c0cbe0c89a4d72470220357a18fc09e164c340a826be0b6e7ae85f462bc8b1e"
    sha256 arm64_ventura:  "0d52752358ec1bacc81641d2b53c15ccac366efc385e6027d4d1fbef4c7b9841"
    sha256 arm64_monterey: "6291e8626fe670712622c21dca1d4e45fafb664cefc40593f3c5190f40b87b98"
    sha256 sonoma:         "208ae92694b44010185956bb1b3198c4cc59327069d72406c034b930d7a366c4"
    sha256 ventura:        "360d4e0300de51e9c312117010a640d456468708ceb19103698446e15fa10469"
    sha256 monterey:       "9b78a3147659fe6d9aea8afca11c05571d0aeb3e62a6a0f8841f3089178d40f4"
    sha256 x86_64_linux:   "52cb4768633b7b9e50c1574ad81db4c380e5a12110ea89e9126918d037182f4b"
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
