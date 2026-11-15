class GoCamo < Formula
  desc "Secure image proxy server"
  homepage "https://github.com/cactus/go-camo"
  url "https://github.com/cactus/go-camo/archive/refs/tags/v3.1.tar.gz"
  sha256 "255081875bd70918a8f9a72ab6ea06a047cf5fb2eef8618c5c12a259787616bf"
  license "MIT"
  head "https://github.com/cactus/go-camo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "58a649464b802dac0e5c4050fe81711b62615a9544768cd05dba663def3f312f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5ffc650849bbf9725325b120fc17da6dd6d45cc3ab55af252575c23bbe34288f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "eabaadbe864707dd5c80d4db8f23436bb8fe5d6ae56ae27adb3c49008080fff7"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "db67533b9e84e55b4f5c925b2e670892f8b23fc38b85b9cdda63919fb04d91fe"
    sha256 cellar: :any,                 x86_64_linux:      "4e73e9e1e2978502ff7162d6cc6c10e229a22b1d55e2e27b24eafd3a86e1a9cb"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X main.ServerVersion=#{version}"
    tags = "netgo,production"
    system "go", "build", *std_go_args(ldflags:, tags:), "./cmd/go-camo"
    system "go", "build", *std_go_args(ldflags:, tags:, output: bin/"url-tool"), "./cmd/url-tool"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/go-camo --version")
    assert_match version.to_s, shell_output("#{bin}/url-tool --version")

    port = free_port
    spawn bin/"go-camo", "--key", "somekey", "--listen", "127.0.0.1:#{port}", "--metrics"
    sleep 1
    assert_match "200 OK", shell_output("curl -sI http://localhost:#{port}/metrics")

    url = "https://golang.org/doc/gopher/frontpage.png"
    encoded = shell_output("#{bin}/url-tool -k 'test' encode -p 'https://img.example.org' '#{url}'").chomp
    decoded = shell_output("#{bin}/url-tool -k 'test' decode '#{encoded}'").chomp
    assert_equal url, decoded
  end
end
