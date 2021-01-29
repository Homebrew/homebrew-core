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
    sha256 "a647293f345eead229f83e2707fb2c542958c9b4e33fb0bf4e63c7217548d392" => :big_sur
    sha256 "079f2087995cd399f1c99dddc5f1d6d92e55af2facf67b427fb633a80faba842" => :catalina
    sha256 "fc1b26dc8f000fc728c26bbedff9f9ab0d6f2071ef17eeb4a0f71c9626184cc7" => :mojave
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
