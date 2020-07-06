class ClojureLsp < Formula
  desc "Language Server (LSP) for Clojure"
  homepage "https://github.com/snoe/clojure-lsp"
  # Switch to use git tag/revision as needed by `lein-git-version`
  url "https://github.com/snoe/clojure-lsp.git",
    :tag      => "release-20200706T152722",
    :revision => "2ced4b1f218223e4bcf534866021be5574fcf3cd"
  version "20200706T152722"
  license "MIT"
  head "https://github.com/snoe/clojure-lsp.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "21c6a97ca351bd27c5387dc0b1f08d2e962cc83acb0eeccf846b5e9d3b4dfd6a" => :catalina
    sha256 "baf6c0d8b7305262ab14733a6d4325cafdd58f75b43667b2d127ffc4b3174bbd" => :mojave
    sha256 "9c2573331b62fbcb1cbaa91f3f2bec1bfb2722739eefc65d8e87f810b3f9d04f" => :high_sierra
  end

  depends_on "leiningen" => :build
  # The Java Runtime version only recognizes class file versions up to 52.0
  depends_on :java => "1.8"

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
