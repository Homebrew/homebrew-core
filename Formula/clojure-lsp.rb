class ClojureLsp < Formula
  desc "Language Server (LSP) for Clojure"
  homepage "https://github.com/snoe/clojure-lsp"
  # Switch to use git tag/revision as needed by `lein-git-version`
  url "https://github.com/snoe/clojure-lsp.git",
    :tag      => "release-20200507T034423",
    :revision => "a1e30bc4c3d84f9cf6c8d5fe097eef2d25676796"
  version "20200507T034423"
  sha256 "7444795a6a9655ae8e1ec1df00392f24bad2a73a1f890353e2b7c98dca681061"
  head "https://github.com/snoe/clojure-lsp.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d4a9a63a1256ed2ab2e327294c817db6f56004025a4c0bf0c64fb0228c239c90" => :catalina
    sha256 "dc1b3cf1a7c579a2f55d2428877182f568aa879ca9dfe8cf0270bdae71be074f" => :mojave
    sha256 "2a671898228b5434fcdd888a0503cb68e53d140029faf687590238e10a908404" => :high_sierra
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
