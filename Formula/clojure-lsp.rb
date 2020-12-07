class ClojureLsp < Formula
  desc "Language Server (LSP) for Clojure"
  homepage "https://github.com/snoe/clojure-lsp"
  # Switch to use git tag/revision as needed by `lein-git-version`
  url "https://github.com/snoe/clojure-lsp.git",
    tag:      "release-20201207T142850",
    revision: "ab32504073688d507b53e47c354733cd6603bc88"
  version "20201207T142850"
  license "MIT"
  head "https://github.com/snoe/clojure-lsp.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "964ed6401a0b2eba48e054c0750be95c72b8b58ec7457057518065f72408152b" => :big_sur
    sha256 "22e53597ad85ef7dcf04ac2262b90065875961112d2584ff6c13fb0b1d96c086" => :catalina
    sha256 "8cf27a5ed1000f03e785739eb8e63847237d70f447ea8dfefc8d76823f5dfc37" => :mojave
  end

  depends_on "leiningen" => :build
  # The Java Runtime version only recognizes class file versions up to 52.0
  depends_on "openjdk@8"

  def install
    system "lein", "uberjar"
    jar = Dir["target/clojure-lsp-*-standalone.jar"][0]
    libexec.install jar
    bin.write_jar_script libexec/File.basename(jar), "clojure-lsp"
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
