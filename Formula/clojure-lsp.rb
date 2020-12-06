class ClojureLsp < Formula
  desc "Language Server (LSP) for Clojure"
  homepage "https://github.com/snoe/clojure-lsp"
  # Switch to use git tag/revision as needed by `lein-git-version`
  url "https://github.com/snoe/clojure-lsp.git",
    tag:      "release-20201205T230541",
    revision: "5f64cef76602d58d91501943f72d2b8e5dc16d98"
  version "20201205T230541"
  license "MIT"
  head "https://github.com/snoe/clojure-lsp.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a085fd28c1a954aee84e0994d5766eaca8132af087e7cc16a05508f24d599100" => :big_sur
    sha256 "4b368c432eedca9c8c2bc833d1aeedb2b2158c9b5f379e8598b300992afcb04b" => :catalina
    sha256 "689aa444c3c9a2329bad3d09930bdaffbe19e04bc4b35d1b193186f5be988212" => :mojave
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
