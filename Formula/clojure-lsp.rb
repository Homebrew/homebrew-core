class ClojureLsp < Formula
  desc "Language Server (LSP) for Clojure"
  homepage "https://github.com/snoe/clojure-lsp"
  url "https://github.com/snoe/clojure-lsp/archive/release-20200121T234305.tar.gz"
  version "20200121T234305"
  sha256 "33d4b1a66beee4e74e9c5bb034f49cdc124732c2fafef486b13a4b3573d0fa5d"
  head "https://github.com/snoe/clojure-lsp.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "95114b39a9096f7279018026bb99a2aa5ba75e828ec66769d7e795409111b6d1" => :catalina
    sha256 "6d37d3893a1cfb5ecdd5ea3a543ca5ccef2cf25d62596e74486f6dff6ce3d29d" => :mojave
    sha256 "d9f2d7991242c2803059b3319bcda915de5c4d5b523ee5da067d28768e8b5a8a" => :high_sierra
    sha256 "d99ed04247a05fb3e3e87b2237832fdf25abc02cc7c2f03ff12ce2b66f7b4e34" => :sierra
  end

  depends_on "leiningen" => :build

  def install
    system "lein", "uberjar"
    jar = Dir["target/clojure-lsp-*-standalone.jar"][0]
    libexec.install jar
    bin.write_jar_script libexec/File.basename(jar), "clojure-lsp"
  end

  test do
    require "Open3"

    begin
      stdin, stdout, _, wait_thr = Open3.popen3("#{bin}/clojure-lsp")
      pid = wait_thr.pid
      stdin.write <<~EOF
        Content-Length: 58

        {"jsonrpc":"2.0","method":"initialize","params":{},"id":1}
      EOF
      assert_match "Content-Length", stdout.gets("\n")
    ensure
      Process.kill "SIGKILL", pid
    end
  end
end
