class ClojureLsp < Formula
  desc "Language Server (LSP) for Clojure"
  homepage "https://github.com/snoe/clojure-lsp"
  url "https://github.com/snoe/clojure-lsp/archive/release-20200314T202821.tar.gz"
  version "20200314T202821"
  sha256 "4a3fb5a4b88ebf286fc2e5dc500bc4ddb65962c05ab21a46453a33d867627433"
  head "https://github.com/snoe/clojure-lsp.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7758a824cf67ec6dcf103d1ebe8edef7455d41a630946ce311b8c0db89796a40" => :catalina
    sha256 "6b84d8a6fa6558ce83da30111923ca35b8d0afd3021796c7193eff2add049dc9" => :mojave
    sha256 "2507e16ae03bf19cf30415b14516889a6fec3ea8e88dca024296231c748faca5" => :high_sierra
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
