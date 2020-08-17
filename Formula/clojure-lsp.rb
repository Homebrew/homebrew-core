class ClojureLsp < Formula
  desc "Language Server (LSP) for Clojure"
  homepage "https://github.com/snoe/clojure-lsp"
  # Switch to use git tag/revision as needed by `lein-git-version`
  url "https://github.com/snoe/clojure-lsp.git",
    tag:      "release-20200817T204951",
    revision: "0e5385f42ab2fd5043b49b4b792ba03d6c78128e"
  version "20200817T204951"
  license "MIT"
  head "https://github.com/snoe/clojure-lsp.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0c1a43ea4e2cd6020a7cb2f7d489547a4788fef8d7316703155e992a3e860d99" => :catalina
    sha256 "0568435a50c7500890285e867a56f04148cc3cf95e8d15e34279b9ecb847654a" => :mojave
    sha256 "e9922a6046e89c691a424aa7f556a61a7ac8aeb26a00e16bb7035014304f9428" => :high_sierra
  end

  depends_on "leiningen" => :build
  # The Java Runtime version only recognizes class file versions up to 52.0
  depends_on java: "1.8"

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
