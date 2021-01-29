class ClojureLsp < Formula
  desc "Language Server (LSP) for Clojure"
  homepage "https://github.com/snoe/clojure-lsp"
  # Switch to use git tag/revision as needed by `lein-git-version`
  url "https://github.com/snoe/clojure-lsp.git",
      tag:      "2021.01.28-03.03.16",
      revision: "fe50704d5e14009d4eeeb5a88a451d0ef4474838"
  version "2021.01.28-03.03.16"
  license "MIT"
  version_scheme 1
  head "https://github.com/snoe/clojure-lsp.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a647293f345eead229f83e2707fb2c542958c9b4e33fb0bf4e63c7217548d392" => :big_sur
    sha256 "079f2087995cd399f1c99dddc5f1d6d92e55af2facf67b427fb633a80faba842" => :catalina
    sha256 "fc1b26dc8f000fc728c26bbedff9f9ab0d6f2071ef17eeb4a0f71c9626184cc7" => :mojave
  end

  depends_on "leiningen" => :build
  # The Java Runtime version only recognizes class file versions up to 52.0
  depends_on "openjdk@11"

  def install
    system "lein", "uberjar"
    jar = Dir["target/clojure-lsp-*-standalone.jar"][0]
    libexec.install jar
    bin.write_jar_script libexec/File.basename(jar), "clojure-lsp"
  end

  test do
    input =
      "Content-Length: 152\r\n" \
      "\r\n" \
      "{\"jsonrpc\":\"2.0\",\"id\":0,\"method\":\"initialize\",\"params\":{\"" \
      "processId\":88075,\"rootUri\":null,\"capabilities\":{},\"trace\":\"ver" \
      "bose\",\"workspaceFolders\":null}}\r\n"

    output = "Content-Length:"

    assert_match output, pipe_output("#{bin}/clojure-lsp", input, 0)
  end
end
