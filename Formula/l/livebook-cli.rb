class LivebookCli < Formula
  desc "Code notebooks for Elixir developers"
  homepage "https://livebook.dev"
  url "https://github.com/livebook-dev/livebook/archive/refs/tags/v0.19.9.tar.gz"
  sha256 "9be368c4a8c58f780af453e21b52dd17204390a037cddc119230787b2e4de58e"
  license "Apache-2.0"
  head "https://github.com/livebook-dev/livebook.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6df9eb7509af8c104f8104e4ce871de73964ccf5a09f107822334723ab1908e2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "935fa9188488db9b0a9ec0920a5ff9d5bee9b6003be3661dbcc42be3d1188865"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "05c42ef0348ef2cc4db161ac2a94784c8d029adda71936c7dd4b0187f3231715"
    sha256 cellar: :any_skip_relocation, sonoma:        "b50994c84f55eea9b82f25791c632c91fae2121b858b7ee8a29ccc581c5314bc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "19f06c33207b0122ea0732f23d4c7422799697449952bfa7e96dbd40749689cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "63804d1240546b246fb99334b720d3325ff1a5f087f9e195141c7394945ecd76"
  end

  depends_on "elixir" => :build
  depends_on "erlang"

  def install
    ENV["MIX_ENV"] = "prod"

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
