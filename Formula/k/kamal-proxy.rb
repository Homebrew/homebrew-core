class KamalProxy < Formula
  desc "Lightweight proxy server for Kamal"
  homepage "https://kamal-deploy.org/"
  url "https://github.com/basecamp/kamal-proxy/archive/refs/tags/v0.8.4.tar.gz"
  sha256 "8015de823ab157a70e8b84dd0de581b645f20b4604dc6c69f2ab40cfaf48cb9b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4d2e214390913825bae25ee815099aaba61d2231b8f33ae759207605cb1f6fa2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4d2e214390913825bae25ee815099aaba61d2231b8f33ae759207605cb1f6fa2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4d2e214390913825bae25ee815099aaba61d2231b8f33ae759207605cb1f6fa2"
    sha256 cellar: :any_skip_relocation, sonoma:        "f7c5e514d2f53e56cae8128a9b8355435b1e1eb953c7b4411149e56835048943"
    sha256 cellar: :any_skip_relocation, ventura:       "f7c5e514d2f53e56cae8128a9b8355435b1e1eb953c7b4411149e56835048943"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c7e445228a2d5068d3adf5956c418ca176d29556c8dd333bb85aa9e11130ebc"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/kamal-proxy"
  end

  test do
    assert_match "HTTP proxy for zero downtime deployments", shell_output(bin/"kamal-proxy")

    read, write = IO.pipe
    port = free_port
    pid = fork do
      exec "#{bin}/kamal-proxy run --http-port=#{port}", out: write
    end

    system "curl -A 'HOMEBREW' http://localhost:#{port} > /dev/null 2>&1"
    sleep 2

    output = read.gets
    assert_match "No previous state to restore", output
    output = read.gets
    assert_match "Server started", output
    output = read.gets
    assert_match "user_agent\":\"HOMEBREW", output
  ensure
    Process.kill("HUP", pid)
  end
end
