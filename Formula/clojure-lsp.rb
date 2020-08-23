class ClojureLsp < Formula
  desc "Language Server (LSP) for Clojure"
  homepage "https://github.com/snoe/clojure-lsp"
  # Switch to use git tag/revision as needed by `lein-git-version`
  url "https://github.com/snoe/clojure-lsp.git",
    tag:      "release-20200819T134828",
    revision: "090d60cbacc7b7f996fac10c06985ae35a5f7de6"
  version "20200819T134828"
  license "MIT"
  head "https://github.com/snoe/clojure-lsp.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "645cdec11f11d3d5260a32f60e80c218486de08c1898cd827ec9b87642c2f982" => :catalina
    sha256 "5a74b33a223ef90e2ad92e9e48b57e9c46df175556f993989a928a9c41500066" => :mojave
    sha256 "2433b623a368302d736e528dad89ce63c1fb6535f6b36630a3aa96b59fc97e89" => :high_sierra
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
