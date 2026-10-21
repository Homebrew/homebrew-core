class Gollama < Formula
  desc "Go manage your Ollama models"
  homepage "https://smcleod.net"
  url "https://github.com/sammcj/gollama/archive/refs/tags/v2.0.7.tar.gz"
  sha256 "7644ac3145809bc06a51e48cbf9c3512c92349e16161473e8953ff641d532bf8"
  license "MIT"
  head "https://github.com/sammcj/gollama.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9f65ea39008a348d9d8efcfbb0e124aa68c62675d77d2b07a8b6c2d8fcc0b73e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e65cc109b52dd3d18743cd8bd15c1892981dafbf7180f055a9f65885837f3a9c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2453ed1c519e0efb69e6dbc564f4c154c93a9f7bca028a790ca559637298ede4"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6cdc13898f529a94afcca48bee301c68672f8c6b2ce0d075b0434c696fee7c05"
    sha256 cellar: :any,                 x86_64_linux:      "d85a0fbbabc7628d235c4ab92d25618e12c1f2a0705f4c773fd819cc0689300d"
  end

  depends_on "go" => :build
  depends_on "ollama" => :test

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.Version=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gollama -v")

    port = free_port
    ENV["OLLAMA_HOST"] = "localhost:#{port}"

    pid = spawn formula_opt_bin("ollama")/"ollama", "serve"
    begin
      sleep 3
      output = shell_output("#{bin}/gollama -h http://localhost:#{port} -s chatgpt")
      assert_match "No matching models found.", output
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end
