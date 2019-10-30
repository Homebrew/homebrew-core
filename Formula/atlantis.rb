class Atlantis < Formula
  desc "Terraform Pull Request Automation tool"
  homepage "https://www.runatlantis.io/"
  url "https://github.com/runatlantis/atlantis/archive/v0.10.1.tar.gz"
  sha256 "98a1dae80acfa1c322007d4a2e29a28733edc386d74b9b3b07608fe64820a843"
  bottle do
    cellar :any_skip_relocation
    sha256 "2fd6477fbbd809c527ddf4d3e3d657357beb58d36d787a6209b5b03185e23ea3" => :catalina
    sha256 "a290d54b94725f6b13bdf24e1005a276904f04a98aac5327dc6a96f8209aa5c0" => :mojave
    sha256 "e358a6af53d5879b3e830bc76af9a25a2064740464fa01aa083f5a627960be6e" => :high_sierra
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
