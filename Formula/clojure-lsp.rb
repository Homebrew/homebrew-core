class ClojureLsp < Formula
  desc "Language Server (LSP) for Clojure"
  homepage "https://github.com/snoe/clojure-lsp"
  url "https://github.com/snoe/clojure-lsp/archive/release-20200305T151710.tar.gz"
  version "20200305T151710"
  sha256 "684f7233f25970e6a6dd2136f0cbaff7812380e9e6da8c6a7fd17fd425ffe44a"
  head "https://github.com/snoe/clojure-lsp.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c18d55000495393516567e0da650f268062bf6ec5f16566cdc64870aa193e969" => :catalina
    sha256 "67c08a8c4013340936bd5890a75fff949a32087b17361a0b8949d7893c287d1c" => :mojave
    sha256 "8ceb86184b71354b9386ae4b354a65528e963b949b0bec9489c7cc29bc8fda28" => :high_sierra
  end

  depends_on "leiningen" => :build

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
