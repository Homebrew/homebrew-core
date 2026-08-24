class ClojureLsp < Formula
  desc "Language Server (LSP) for Clojure"
  homepage "https://clojure-lsp.io"
  url "https://github.com/clojure-lsp/clojure-lsp/releases/download/2026.07.06-14.34.19/clojure-lsp-standalone.jar"
  version "2026.07.06-14.34.19"
  sha256 "194f7639e2b32a6e36432fba7cc4a9b128f45889d2ad05725551523f164d6846"
  license "MIT"
  version_scheme 1
  head "https://github.com/clojure-lsp/clojure-lsp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d{4}(?:[.-]\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b90c38665d79652539acc613c4657804723e0691348f849da5792cc62132914a"
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
