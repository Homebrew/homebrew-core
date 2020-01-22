class Atlantis < Formula
  desc "Terraform Pull Request Automation tool"
  homepage "https://www.runatlantis.io/"
  url "https://github.com/runatlantis/atlantis/archive/v0.11.1.tar.gz"
  sha256 "62e1ceeb1aee75f7be82b4158c44eed06e17ce896dd47879e93550d10f05e330"
  bottle do
    cellar :any_skip_relocation
    sha256 "151c59e26e143ce1adc944ae371f62cd2c6fb51f21a9c923c6d42ceb872f88fd" => :catalina
    sha256 "890decc9e74bc3e8feaf27523bbc24e34b32aff32cc87d53e33a9c4ae8b7ffd8" => :mojave
    sha256 "328348dfe1414b2768957ebbd92b3de6d7552456904f74b32c702d42e371d35b" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "terraform"

  def install
    system "go", "build", "-ldflags", "-s -w", "-trimpath", "-o", bin/"atlantis"
  end

  test do
    system bin/"atlantis", "version"
    port = 4141
    loglevel = "info"
    gh_args = "--gh-user INVALID --gh-token INVALID --gh-webhook-secret INVALID --repo-whitelist INVALID"
    command = bin/"atlantis server --atlantis-url http://invalid/ --port #{port} #{gh_args} --log-level #{loglevel}"
    pid = Process.spawn(command)
    system "sleep", "5"
    output = `curl -vk# 'http://localhost:#{port}/' 2>&1`
    assert_match %r{HTTP\/1.1 200 OK}m, output
    assert_match "atlantis", output
    Process.kill("TERM", pid)
  end
end
