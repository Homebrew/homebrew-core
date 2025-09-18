class Crystalline < Formula
  desc "Language Server Protocol implementation for Crystal"
  homepage "https://github.com/elbywan/crystalline"
  url "https://github.com/elbywan/crystalline/archive/refs/tags/v0.17.1.tar.gz"
  sha256 "3e8f4c3f41830092300219ef91c3d03e15536774ef18a5395ff6a9fffc27be5b"
  license "MIT"
  revision 1

  bottle do
    sha256 arm64_tahoe:   "76adf0ed068bbdca5fea8ae6c46e97e72ac2a9b0f942cd895b7b82f949833508"
    sha256 arm64_sequoia: "9880d25d405a18e5b15ca3285d636fe7e88c7f8d2c23d475f9d7389d83c7bccb"
    sha256 arm64_sonoma:  "fa4289ff006887a7cf83a094eb5429785fdedfad7423626de75fd20dbb9e843d"
    sha256 arm64_ventura: "5e25f739442d1ec0a9c2d246be380a397dfb4eabe27e5c2525f9deb758b37afa"
    sha256 sonoma:        "93f3fdfd3110c2c4335ff7c620fda4f2656c82b8af01af4531df3155a964630e"
    sha256 ventura:       "36692b831edc7d4b9e9fa77f2fc04e36c1accc353ae9dd6ef91d0fbdde501990"
    sha256 arm64_linux:   "b74e77b5867ae143deb672dbd7387706bcd957c7851845222183c49ad0b914c8"
    sha256 x86_64_linux:  "28e4ffc22551602bec7b10f5e27f0e4011f8778e651c7bb43fe749d1b229b1ed"
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
