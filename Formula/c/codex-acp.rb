class CodexAcp < Formula
  desc "Use Codex from ACP-compatible clients such as Zed!"
  homepage "https://github.com/zed-industries/codex-acp"
  url "https://github.com/zed-industries/codex-acp/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "0813038f51360362221ea8a525c46b5de6272659bffa63853391d6e264f738d8"
  license "Apache-2.0"
  head "https://github.com/zed-industries/codex-acp.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cb93a1508a5fe0ac2bbe08741d01ae8da27d58db4259a1a18b5f0926a7e37446"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a3366d7766d69d5d52b7ac01ed49b806d91e7793182a98668092a9bf72d7668a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "04a48f94064b02854089944261de81c75f06d93b1baa57fceec96053cbfd0f0d"
    sha256 cellar: :any_skip_relocation, sonoma:        "87ac7a183a38adec3d25bcc54ba0e29b8265bac745a23884eb795bf1467ab91d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5e1baa85540c3db782a933c7107b2758c0a70d22594300471b71250625bb99bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b12e5979e0ea8bd2288f66c58bd7e3904801fb70e8f2901c70f3e28bb626729"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  on_linux do
    depends_on "libcap" => :build
    depends_on "openssl@4"
    depends_on "zlib-ng-compat"
  end

  def install
    ENV["OPENSSL_DIR"] = Formula["openssl@4"].opt_prefix if OS.linux?
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
