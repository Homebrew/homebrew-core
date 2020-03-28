class ClojureLsp < Formula
  desc "Language Server (LSP) for Clojure"
  homepage "https://github.com/snoe/clojure-lsp"
  url "https://github.com/snoe/clojure-lsp/archive/release-20200314T202821.tar.gz"
  version "20200314T202821"
  sha256 "4a3fb5a4b88ebf286fc2e5dc500bc4ddb65962c05ab21a46453a33d867627433"
  head "https://github.com/snoe/clojure-lsp.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "23549a99e02319bcdf24f5d92731358829b9752c4f28a9f9855033b848217adf" => :catalina
    sha256 "ee336e57a5504855a8fb7ec2b1e1336e3b224075726ae4f68910bd2a10b99887" => :mojave
    sha256 "840614a2e8476c132192f925bd7cc677417f8742f21cce48a110bb231a82bea6" => :high_sierra
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
