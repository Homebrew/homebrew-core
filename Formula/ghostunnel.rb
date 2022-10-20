class Ghostunnel < Formula
  desc "Simple SSL/TLS proxy with mutual authentication"
  homepage "https://github.com/ghostunnel/ghostunnel"
  url "https://github.com/ghostunnel/ghostunnel/archive/refs/tags/v1.6.1.tar.gz"
  sha256 "7fb1f9e8f60a6128b8b49cb2d3749b5fafad7d1d8c422adad48f34e240a8be6a"
  license "Apache-2.0"
  head "https://github.com/ghostunnel/ghostunnel.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fe484f4f7c5968a90425f71cf3f1c1eb90f16d10110fc0673b53ce2becf13b2b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "40c23eb108c2d95ef199c0f41954b7880ec46592d0569d7fa062a2b1636eaa8c"
    sha256 cellar: :any_skip_relocation, monterey:       "45894dab1081ca1e552e394f1bb9fd2c0588c81be8b98aeff0dad95fc8ad3966"
    sha256 cellar: :any_skip_relocation, big_sur:        "7bd35cf909c047c9fb53b5daefa9c2fa783090d8c87377ba86b5db73a18abbcd"
    sha256 cellar: :any_skip_relocation, catalina:       "fb1b7aa18186c9a4ea00c9ef5bee5f6e4fdcde76097c4fed2c37d15f3840b734"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dfd567ba5d7174e9c56189e52f5cef6151b57f9bdb5943420fc2ad88a1160e19"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    port = free_port
    fork do
      exec bin/"ghostunnel", "client", "--listen=localhost:#{port}", "--target=localhost:4",
        "--disable-authentication", "--shutdown-timeout=1s", "--connect-timeout=1s"
    end
    sleep 1
    shell_output("curl -o /dev/null http://localhost:#{port}/", 56)
  end
end
