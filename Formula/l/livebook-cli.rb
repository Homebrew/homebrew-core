class LivebookCli < Formula
  desc "Code notebooks for Elixir developers"
  homepage "https://livebook.dev"
  url "https://github.com/livebook-dev/livebook/archive/refs/tags/v0.19.11.tar.gz"
  sha256 "924d9ff52260d8fc44fddd0629594c7f6e2e94b3265643dabbe0c039eaaf1c28"
  license "Apache-2.0"
  head "https://github.com/livebook-dev/livebook.git", branch: "main"

  bottle do
    manifest_sha256 "18fc6156dea6ba0afa72d9863ce00eea8f2a527109f45dbcd97edc8a0786e71b"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8852cf1a56244cb057ca78213408aa7a286908d5561644f2e447b0fa432532c2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "855ebf2ca7ee1f07a5fad8de2ea35f2c7b07d0db53d1ed2f168349cb8e0db313"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "13786c4b2b14b83f7541c9a14ac36096acf17d07c21576076229478939249ee7"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "5e5e3aff9a353c4041971736f2ea4fb7a794b648a46e17323e77a9dbd7858fb5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "befd34fdb21f7417dec6f1d04c43b36ea39c12c5f6af5f1fc06bb4d242e5a52b"
  end

  depends_on "elixir" => :build
  depends_on "node" => :build
  depends_on "erlang"

  def install
    ENV["MIX_ENV"] = "prod"
    # aws_credentials and its plugins use callbacks and catch syntax deprecated by OTP 29.
    ENV["ERL_COMPILER_OPTIONS"] = "[nowarn_deprecated_callback, nowarn_deprecated_catch]"

    system "mix", "local.hex", "--force"
    system "mix", "local.rebar", "--force"
    system "mix", "setup.prod"
    system "mix", "escript.build"

    bin.install "livebook"
    bin.env_script_all_files libexec, LIVEBOOK_SHUTDOWN_ENABLED: "${LIVEBOOK_SHUTDOWN_ENABLED:-true}"
  end

  test do
    ENV["LIVEBOOK_TOKEN_ENABLED"] = "false"

    require "open3"

    port = free_port
    Open3.popen3(bin/"livebook", "server", "--port=#{port}") do |_stdin, stdout, _stderr, wait_thr|
      # Ensure that the server starts
      expected = %r{^\[Livebook\] Application running at http://localhost:#{port}/$}i
      assert_match expected, stdout.readline

      # Ensure that there is a page to visit
      output = shell_output("curl -fsSm5 --retry 5 http://localhost:#{port}")
      assert_match %r{<title>\s*Livebook\s*</title>}i, output
    ensure
      Process.kill "TERM", wait_thr.pid
    end
  end
end
