class ClojureLsp < Formula
  desc "Language Server (LSP) for Clojure"
  homepage "https://github.com/clojure-lsp/clojure-lsp"
  # Switch to use git tag/revision as needed by `lein-git-version`
  url "https://github.com/clojure-lsp/clojure-lsp/releases/download/2021.02.02-14.02.23/clojure-lsp"
  sha256 "33182e16557abf76af9d6246da99539c12be46703aae6d9f8c9825b371165a02"
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
    chmod 0755, "clojure-lsp"
  end

  test do
    require "Open3"

    stdin, stdout, _, wait_thr = Open3.popen3("#{bin}/clojure-lsp")
    pid = wait_thr.pid
    stdin.write <<~EOF
      Content-Length: 58

      {"jsonrpc":"2.0","method":"initialize","params":{},"id":1}
    EOF
    assert_match "Content-Length", stdout.gets("\n")
    Process.kill "SIGKILL", pid
  end
end
