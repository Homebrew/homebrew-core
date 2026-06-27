class Crystalline < Formula
  desc "Language Server Protocol implementation for Crystal"
  homepage "https://github.com/elbywan/crystalline"
  url "https://github.com/elbywan/crystalline/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "c3c8842163a42b4d1b3d31c58ffd0711215add201d9a9a88aa1cabce9179094d"
  license "MIT"

  bottle do
    sha256 arm64_tahoe:   "06d8e49794df8199380884f959056e79574902b2a7f2de214b3674647240b23b"
    sha256 arm64_sequoia: "eae5b7792816da6f70dfddd19af25ecdb6adf90ce98252375bfdcc27a6575c73"
    sha256 arm64_sonoma:  "0b9ae40b72c5090246f95b148bc0e3653332cca462e2ddec212b18f96e7b7ba6"
    sha256 sonoma:        "a783323aa4d4f9e22f6c9e0a21acf98938e9a65a2ea94ff0cfe4984494170614"
    sha256 arm64_linux:   "adca17ee06b1c7d2354cf7495c179c014c8540a145f6a121a08a5da47474cdce"
    sha256 x86_64_linux:  "a3772942bebff7792808080b427b76dd2a4885b982b90c19a0c5e8a77b6fe98a"
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
