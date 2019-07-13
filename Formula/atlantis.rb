class Atlantis < Formula
  desc "Terraform Pull Request Automation tool"
  homepage "https://www.runatlantis.io/"
  url "https://github.com/runatlantis/atlantis/archive/v0.8.3.tar.gz"
  sha256 "26304b0510544ec883f0bb08f7c60794062b4930e6cbaa3396f6d0e66aa813e0"
  bottle do
    cellar :any_skip_relocation
    sha256 "0b4f35f1c7b69bdfd5c197d31f21731ccf9358e61421a4b341e0f6365c7f2c08" => :mojave
    sha256 "3cc4b1a987fb204b3b5accc69c6a3695a591de545b65278c86ff8bf33921d960" => :high_sierra
    sha256 "263e3915c91c290e259d52ecfc979afdaaddf99ab10be60762594e3fa5d30f7d" => :sierra
  end

  depends_on "go" => :build
  depends_on "terraform"

  def install
    ENV["GOPATH"] = buildpath
    dir = "src/github.com/runatlantis/atlantis"
    build_dir = buildpath/dir
    build_dir.install buildpath.children

    cd dir do
      system "go", "build", "-o", "atlantis"
      bin.install "atlantis"
    end
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
