class Crystalline < Formula
  desc "Language Server Protocol implementation for Crystal"
  homepage "https://github.com/elbywan/crystalline"
  url "https://github.com/elbywan/crystalline/archive/refs/tags/v0.16.0.tar.gz"
  sha256 "4639607061f8d137d2dd1a66cfa673052930d628ef9da7f65f8cab70c615e6e1"
  license "MIT"
  revision 2

  bottle do
    sha256 arm64_sequoia: "6e2952bb70e3eec710e218913810efb07921378b35aa31b0ca29f02855cd94a5"
    sha256 arm64_sonoma:  "02cbaa41bb8451c67bd056f2633129e7e617a11e805ebc80871ecf0498a27870"
    sha256 arm64_ventura: "fac4533b13c54646be003ca911cbff395340ed2faf72e6b30fb51f34bd701ae2"
    sha256 sonoma:        "e44fba275c146fc00e9405438c6e3f7ebf55d597799cce183790d0f0521ff61f"
    sha256 ventura:       "328124c5b8c4d94f952a1770f566f4660d85831e845cd7b0433a4a21ed448454"
    sha256 x86_64_linux:  "fe9bd89417815800b5fdb69c8091bf9ab9adcf327fe2ab29095815a030a87396"
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
