class Crystalline < Formula
  desc "Language Server Protocol implementation for Crystal"
  homepage "https://github.com/elbywan/crystalline"
  url "https://github.com/elbywan/crystalline/archive/refs/tags/v0.20.0.tar.gz"
  sha256 "8693e91c0f2afa9afa66885aa2bbdc971e539ff95e3d89b2f5d499d07acad02d"
  license "MIT"
  revision 1

  bottle do
    rebuild 1
    sha256 arm64_golden_gate: "5d1b267aa150b0861e16323f7e77ff141546aabaa631b951a8215ff1265fe4ad"
    sha256 arm64_tahoe:       "ac4becdc7a7232e0ccdeb03db13db3530c8cf52920c835574316fde46b102ec4"
    sha256 arm64_sequoia:     "bbbfb855eaecc0fc7f6977e9ecf6cbbf3454d65885eaabe65a9adbf03027b76f"
    sha256 arm64_linux:       "00cef19501f480b1b11f4d94c728762b5c8075d30171a7b0e3d86f7987ce5e15"
    sha256 x86_64_linux:      "1fcbf4eae5e2e4f3ef37cd665a5fbfd576b8af74d823e17259f0ddba3e0295de"
  end

  depends_on "bdw-gc"
  depends_on "crystal"
  depends_on "libyaml"
  depends_on "llvm"
  depends_on "pcre2"

  deny_network_access!

  def fetch
    system "shards", "install", "--production", "--skip-postinstall"
  end

  def install
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
