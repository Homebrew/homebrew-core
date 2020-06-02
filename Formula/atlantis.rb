class Atlantis < Formula
  desc "Terraform Pull Request Automation tool"
  homepage "https://www.runatlantis.io/"
  url "https://github.com/runatlantis/atlantis/archive/v0.13.0.tar.gz"
  sha256 "7e06f1e4d9410611763f2a9da3d45ecba6921be77a8f5d1ebba722047cfa081f"

  bottle do
    cellar :any_skip_relocation
    sha256 "5b243c7547d8677faf4e3d41c1161e9e9cad98daa9c4e95c2d7b4a89adf3701b" => :catalina
    sha256 "37995792e2f0b45b7e7689d7708186f3db4d25a990742b8d79f7f3187bdda64b" => :mojave
    sha256 "219925593413c8337ce48452590d67b302b6ad5da941b263dee69071596a03ae" => :high_sierra
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
    assert_match %r{HTTP/1.1 200 OK}m, output
    assert_match "atlantis", output
    Process.kill("TERM", pid)
  end
end
