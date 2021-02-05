class ClojureLsp < Formula
  desc "Language Server (LSP) for Clojure"
  homepage "https://github.com/clojure-lsp/clojure-lsp"
  # Switch to use git tag/revision as needed by `lein-git-version`
  url "https://github.com/clojure-lsp/clojure-lsp.git",
      tag:      "2021.02.04-02.08.58",
      revision: "a88950f4c742460bf4621e776929f1a22c547e6e"
  version "2021.02.04-02.08.58"
  license "MIT"
  version_scheme 1
  head "https://github.com/clojure-lsp/clojure-lsp.git"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "a647293f345eead229f83e2707fb2c542958c9b4e33fb0bf4e63c7217548d392"
    sha256 cellar: :any_skip_relocation, catalina: "079f2087995cd399f1c99dddc5f1d6d92e55af2facf67b427fb633a80faba842"
    sha256 cellar: :any_skip_relocation, mojave:   "fc1b26dc8f000fc728c26bbedff9f9ab0d6f2071ef17eeb4a0f71c9626184cc7"
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
    require "Open3"

    print "testing"
    system "file", "#{bin}/clojure-lsp"
    stdin, _stdout, stderr, wait_thr = Open3.popen3("#{bin}/clojure-lsp")
    print Dir.entries("#{bin}")
    print "testing2"
    pid = wait_thr.pid
    print "testing3"
    stdin.write <<~EOF
      Content-Length: 59

      {"jsonrpc":"2.0","method":"initialize","params":{},"id":1}

    EOF

    print "testing4"
    assert_match "Content-Length", stderr.gets
    print "testing5"
    Process.kill "SIGKILL", pid
    print "testing6"
  end
end
