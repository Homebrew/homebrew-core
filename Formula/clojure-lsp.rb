class ClojureLsp < Formula
  desc "Language Server (LSP) for Clojure"
  homepage "https://github.com/clojure-lsp/clojure-lsp"
  # Switch to use git tag/revision as needed by `lein-git-version`
  url "https://github.com/clojure-lsp/clojure-lsp.git",
      tag:      "2021.03.01-19.18.54",
      revision: "3c2dde99451a545da61d6a30ca3e7071581a1aa9"
  version "20210301T191854"
  license "MIT"
  head "https://github.com/clojure-lsp/clojure-lsp.git"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "a647293f345eead229f83e2707fb2c542958c9b4e33fb0bf4e63c7217548d392"
    sha256 cellar: :any_skip_relocation, catalina: "079f2087995cd399f1c99dddc5f1d6d92e55af2facf67b427fb633a80faba842"
    sha256 cellar: :any_skip_relocation, mojave:   "fc1b26dc8f000fc728c26bbedff9f9ab0d6f2071ef17eeb4a0f71c9626184cc7"
  end

  depends_on "leiningen" => :build
  # The Java Runtime version only recognizes class file versions up to 52.0
  depends_on "openjdk@11"

  def install
    system "lein", "uberjar"
    jar = Dir["target/clojure-lsp-*-standalone.jar"][0]
    libexec.install jar
    bin.write_jar_script libexec/File.basename(jar), "clojure-lsp", java_version: "11"
  end

  test do
    input =
      "Content-Length: 152\r\n" \
      "\r\n" \
      "{\"jsonrpc\":\"2.0\",\"id\":1,\"method\":\"initialize\",\"params\":{\"" \
      "processId\":88075,\"rootUri\":null,\"capabilities\":{},\"trace\":\"ver" \
      "bose\",\"workspaceFolders\":null}}\r\n"

    output = pipe_output("#{bin}/clojure-lsp", input, 0)
    assert_match "Content-Length", output
  end
end
