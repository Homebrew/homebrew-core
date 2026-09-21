class Crystalline < Formula
  desc "Language Server Protocol implementation for Crystal"
  homepage "https://github.com/elbywan/crystalline"
  url "https://github.com/elbywan/crystalline/archive/refs/tags/v0.20.0.tar.gz"
  sha256 "8693e91c0f2afa9afa66885aa2bbdc971e539ff95e3d89b2f5d499d07acad02d"
  license "MIT"

  bottle do
    sha256 arm64_golden_gate: "9dbee58249b91669e31b946cbbbdb5047a749e110c39506f381e1c265d4accef"
    sha256 arm64_tahoe:       "53ee7da763c8fc480e2808debfbd0cd0606b8ec2c024a493bd816c6fdf49223e"
    sha256 arm64_sequoia:     "a9bf68068f4926e1440f634f3c9b3363d30d13deb052b652656781947e52c404"
    sha256 arm64_linux:       "6dec77b52072ddfbdcb23f290ad40b53aecf159cde525ce4dff7668382c4fea5"
    sha256 x86_64_linux:      "9857bd43467e458008b04b7ae5701475b280d23fef6dc34412784db199fe8cb1"
  end

  depends_on "bdw-gc"
  depends_on "crystal"
  depends_on "libevent"
  depends_on "libyaml"
  depends_on "llvm@22"
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
