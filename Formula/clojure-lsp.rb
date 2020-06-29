class ClojureLsp < Formula
  desc "Language Server (LSP) for Clojure"
  homepage "https://github.com/snoe/clojure-lsp"
  # Switch to use git tag/revision as needed by `lein-git-version`
  url "https://github.com/snoe/clojure-lsp.git",
    :tag      => "release-20200629T153107",
    :revision => "0c8a42b4b46b1284a4b2c226c24a39a5e3fc2447"
  version "20200629T153107"
  head "https://github.com/snoe/clojure-lsp.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b72c56932c73b64a7163c5c730f288c92115293f43e77c3d50068c80dfc7fa86" => :catalina
    sha256 "3407010120d7a7e9db49f83f9894bd3f1d4f4785ee41e8e941f250bc1497f7b2" => :mojave
    sha256 "90f7c7bc432da0ce485e8d656e7664dc74647fc081c7013a094b90324b7e20c1" => :high_sierra
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
