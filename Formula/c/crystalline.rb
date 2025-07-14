class Crystalline < Formula
  desc "Language Server Protocol implementation for Crystal"
  homepage "https://github.com/elbywan/crystalline"
  url "https://github.com/elbywan/crystalline/archive/refs/tags/v0.17.1.tar.gz"
  sha256 "3e8f4c3f41830092300219ef91c3d03e15536774ef18a5395ff6a9fffc27be5b"
  license "MIT"

  bottle do
    sha256 arm64_sequoia: "87a66475cc7c310d5a9ca86451588753fa013793a29647adc860a722d44262b3"
    sha256 arm64_sonoma:  "55781acbd516f945fa2a882e4791c2eb78eebe8a67c618204dad015d960b93af"
    sha256 arm64_ventura: "497f4eb216f23ed797a8d23b0430ce78156d865604c2e16d95aa3c7068aef792"
    sha256 sonoma:        "7633dc8f2abafcfe175aa69a8d85b75b9ce7c95a07a46a24cb4037c81625b035"
    sha256 ventura:       "2de8e6d021d4fef3cc3f3c896f03ddafc8e0003daccc7fdfb8687968e2b643c2"
    sha256 arm64_linux:   "7378baeedc88e661685c01cb031a0267dcf6969c071b5d8abcfa23b3a4e9d5e2"
    sha256 x86_64_linux:  "f99684dd3f96d2888b1429df00c6aef334cf35e5da5a6dab025e3192a57574f2"
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
