class KamalProxy < Formula
  desc "Lightweight proxy server for Kamal"
  homepage "https://kamal-deploy.org/"
  url "https://github.com/basecamp/kamal-proxy/archive/refs/tags/v0.10.2.tar.gz"
  sha256 "5c75d24ab6110391f62e7a73b913fc8f37f4c7451b629fe2f26a7d8768c7d77e"
  license "MIT"
  head "https://github.com/basecamp/kamal-proxy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3d2436ca5e40e7e78f04d24d2d6670a8cf744d4580a5b385bc67f54ca8899e56"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "cf6bf075c80406da47a2da5289018bfaa4758074a81b61a1ed8b1d11f965087d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "72085fb4acb71358cf4b4b7ed26fb5f562e236892eccd2134e9bbbbe6f06d9c6"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "018e0157fa0e74da62946c31daed42af44a5d39c8e42841f32730ea2ef2ad4a2"
    sha256 cellar: :any,                 x86_64_linux:      "8fa080a202c86283caeda21f8dc7c312cd56e37c6245850c6b1c1317b9b80935"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args, "./cmd/kamal-proxy"
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
    assert_match "Starting kamal-proxy", output
  ensure
    Process.kill("HUP", pid)
  end
end
