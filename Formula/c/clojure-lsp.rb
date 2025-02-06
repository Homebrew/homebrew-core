class ClojureLsp < Formula
  desc "Language Server (LSP) for Clojure"
  homepage "https://github.com/clojure-lsp/clojure-lsp"
  url "https://github.com/clojure-lsp/clojure-lsp/releases/download/2025.01.22-23.28.23/clojure-lsp-standalone.jar"
  version "20250122T232823"
  sha256 "c0f6c09f2b08ebf79ac6f73f4319383a9a434d08acf007284629a1ae23bfbc6c"
  license "MIT"
  head "https://github.com/clojure-lsp/clojure-lsp.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^(?:release[._-])?v?(\d+(?:[T/.-]\d+)+)$}i)
    strategy :git do |tags, regex|
      # Convert tags like `2021.03.01-19.18.54` to `20210301T191854` format
      tags.filter_map { |tag| tag[regex, 1]&.delete(".")&.gsub(%r{[/-]}, "T") }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4dce783e12e4a47f19f6e6bebe8db411e1146e5acbb5b08daa234042dac6a047"
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
