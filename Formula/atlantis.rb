class Atlantis < Formula
  desc "Terraform Pull Request Automation tool"
  homepage "https://www.runatlantis.io/"
  url "https://github.com/runatlantis/atlantis/archive/v0.11.0.tar.gz"
  sha256 "35e687cc00c21cf77d73837106830854405320f5f189366635190adb2753729e"
  bottle do
    cellar :any_skip_relocation
    sha256 "ee357fdb4fd86ae1b82255fa8fa1d55d51bd7fd4a5bafbf36fef04442c0946be" => :catalina
    sha256 "b4d357f53b25fd4fc503edf532a8f6ab30cc7455cf3953c02d9c96ee21dbdc8b" => :mojave
    sha256 "8c44712f5de5dee007a5e64049c7079d795e7741cb0c8c7a225bd6cda6add5be" => :high_sierra
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
