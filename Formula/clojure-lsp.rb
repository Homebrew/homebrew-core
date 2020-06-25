class ClojureLsp < Formula
  desc "Language Server (LSP) for Clojure"
  homepage "https://github.com/snoe/clojure-lsp"
  # Switch to use git tag/revision as needed by `lein-git-version`
  url "https://github.com/snoe/clojure-lsp.git",
    :tag      => "release-20200624T142700",
    :revision => "28e5609e45b83e8f2e335b9ef9be28f011528d83"
  version "20200624T142700"
  head "https://github.com/snoe/clojure-lsp.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f69683f49261e6ebdee304310c3ccc0e7cdc52b24a657a82f3d3825a11ce7ce8" => :catalina
    sha256 "36bb166a9580dc3bd05b6c83af13854964ffd2af45a8c3ae4a21672e219c112b" => :mojave
    sha256 "697dd353717c8c0f5685735f5b210b62fb294a03acaacfb2ad5c83a039347d50" => :high_sierra
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
