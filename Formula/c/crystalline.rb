class Crystalline < Formula
  desc "Language Server Protocol implementation for Crystal"
  homepage "https://github.com/elbywan/crystalline"
  url "https://github.com/elbywan/crystalline/archive/refs/tags/v0.17.1.tar.gz"
  sha256 "3e8f4c3f41830092300219ef91c3d03e15536774ef18a5395ff6a9fffc27be5b"
  license "MIT"
  revision 2

  bottle do
    sha256 arm64_tahoe:   "7647fb168c313d4d25f4b21888b3afcb144986451952f8d621b2f1b4381065df"
    sha256 arm64_sequoia: "c384d158cd61e22df961c05b010996766679faf30cbfcfa06da965d678976b74"
    sha256 arm64_sonoma:  "d5557e7ef3522dac04fb85b186cbde0348ab7dbbb8f14f1093d3680843767791"
    sha256 sonoma:        "347bad1d0b85a7387eabfc33429a74d7eb983667940b569f5f4fc3c36f63337a"
    sha256 arm64_linux:   "263005d3911af92e69ab2f818d0d0d65bfee6fc805cbb7a6be6a3f9466fbcd7c"
    sha256 x86_64_linux:  "92b9d14b44b3d4af23b559024db819723f34a0d491e839ceae54a237e2357cb4"
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
