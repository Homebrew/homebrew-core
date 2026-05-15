class ClojureLsp < Formula
  desc "Language Server (LSP) for Clojure"
  homepage "https://github.com/clojure-lsp/clojure-lsp"
  url "https://github.com/clojure-lsp/clojure-lsp/releases/download/2026.05.05-12.58.26/clojure-lsp-standalone.jar"
  version "2026.05.05-12.58.26"
  sha256 "a97f2c1fbf82e9b5aea588540b7454503201150b7fba4f3a048d4c50d936b7bd"
  license "MIT"
  version_scheme 1
  head "https://github.com/clojure-lsp/clojure-lsp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d{4}(?:[.-]\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b040d54786335630b4bbe1e950a316bf57f74902d8b726ea91b93c50000964bd"
  end

  depends_on "openjdk"

  def install
    libexec.install "clojure-lsp-standalone.jar"
    bin.write_jar_script libexec/"clojure-lsp-standalone.jar", "clojure-lsp"
  end

  test do
    require "open3"

    json = <<~JSON
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

    Open3.popen3(bin/"clojure-lsp") do |stdin, stdout|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      assert_match(/^Content-Length: \d+/i, stdout.readline)
    end
  end
end
