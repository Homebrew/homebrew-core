class LivebookCli < Formula
  desc "Code notebooks for Elixir developers"
  homepage "https://livebook.dev"
  url "https://github.com/livebook-dev/livebook/archive/refs/tags/v0.19.10.tar.gz"
  sha256 "a4ddd8a73e1c663bdd1ec7b33aaaca5390912c0541a50301c7a8cf652b095538"
  license "Apache-2.0"
  head "https://github.com/livebook-dev/livebook.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5a13fff8b5dde469b9b8d10dbdb242807a4fc5b4911c05b99de9470a5a16322c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4dbcc26b243423dd80f505b23a783f7528b361d7f404ba3ac7b13033f3e927a0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "67fc352c30e977326071b2d45e813bd4b5aca625766a1232a10b6978d35b8da6"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "97a38b960b65a5c21005ab4676f17d3ce1f93cf22e3b40601586dc6a84593787"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "b1306b5af117cede744913ae2bfde5397a6aa304eb62bc949f3e4eafd0f70787"
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
