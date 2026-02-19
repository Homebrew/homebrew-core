class CodexAcp < Formula
  desc "Use Codex from ACP-compatible clients such as Zed!"
  homepage "https://github.com/zed-industries/codex-acp"
  url "https://github.com/zed-industries/codex-acp/archive/refs/tags/v0.9.4.tar.gz"
  sha256 "dd95109710733ad1f837aa18accb2a61b1cae47be2caeef2a76fde7e647e8e26"
  license "Apache-2.0"
  head "https://github.com/zed-industries/codex-acp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fcb5be0985835baccf4b19225f1b1e5ce02f1f2f41f0c5118c7667b60061fdea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "92a02f272413ba4ccc4ac61d1768d5a156c3583acc35126edc849113b3654231"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0df056eb8c39d9c3edf0830f6c3c4d100ce7eb68176f60d089ff4bf10f69ee57"
    sha256 cellar: :any_skip_relocation, sonoma:        "f9e2bdef250bfc00cf02d8187aa10a017508e66bc2038e5b666cb861a20f7176"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8b85c5771707f4d8af1860e94f709302d725791a7cacd350ccc02481103dfe72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e251c75b866da65aa6505142530a5d4fd6f3f6030ff51e2fa0eeb5a93b03a99"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "libcap"
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    require "open3"
    require "timeout"

    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":1}}
    JSON

    Open3.popen3(bin/"codex-acp") do |stdin, stdout, _stderr, wait_thr|
      stdin.write(json)
      stdin.close

      line = Timeout.timeout(15) { stdout.gets }
      assert_match "\"protocolVersion\":1", line
    ensure
      if wait_thr&.alive?
        begin
          Process.kill("TERM", wait_thr.pid)
        rescue Errno::ESRCH
          # Process already exited between alive? check and kill.
        end
      end
    end
  end
end
