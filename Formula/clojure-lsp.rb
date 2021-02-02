class ClojureLsp < Formula
  desc "Language Server (LSP) for Clojure"
  homepage "https://github.com/clojure-lsp/clojure-lsp"
  # Switch to use git tag/revision as needed by `lein-git-version`
  url "https://github.com/clojure-lsp/clojure-lsp/releases/download/2021.02.02-14.02.23/clojure-lsp"
  sha256 "33182e16557abf76af9d6246da99539c12be46703aae6d9f8c9825b371165a02"
  license "MIT"
  version_scheme 1
  head "https://github.com/snoe/clojure-lsp.git"
  bottle :unneeded

  # The Java Runtime version only recognizes class file versions up to 52.0
  depends_on "openjdk@11"

  def install
    bin.install "clojure-lsp"
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
