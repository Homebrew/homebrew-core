class Atlantis < Formula
  desc "Terraform Pull Request Automation tool"
  homepage "https://www.runatlantis.io/"
  url "https://github.com/runatlantis/atlantis/archive/v0.8.3.tar.gz"
  sha256 "26304b0510544ec883f0bb08f7c60794062b4930e6cbaa3396f6d0e66aa813e0"
  bottle do
    cellar :any_skip_relocation
    sha256 "ac99ca2ebd22dbe7144cf4b5b217afd08216bd98f3f93af7224c487de8775864" => :mojave
    sha256 "c049e89061957ca6b13b554f4dffce92661ced4768e310ea8d9cdc646d045ee7" => :high_sierra
    sha256 "1f968aec6c399f16381e02cdfaa0ae31e88d097fb8584d7a8e25e7e363f15af9" => :sierra
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
