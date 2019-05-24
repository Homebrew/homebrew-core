class Atlantis < Formula
  desc "Terraform Pull Request Automation tool"
  homepage "https://www.runatlantis.io/"
  url "https://github.com/runatlantis/atlantis/archive/v0.8.0.tar.gz"
  sha256 "5b53152f0eda41f4e5c2b9727e262dea35fb7da46fc0e0eb732956675f0bed8b"
  bottle do
    cellar :any_skip_relocation
    sha256 "6878ee7b1a4be1cd27f4a747b6f7aa7ff8f0297f8f66d876da679eed8882ab67" => :mojave
    sha256 "b44af83b9776cf66905c028925ad89d8e5342ff5447858d572c319f5fcd179fc" => :high_sierra
    sha256 "4fe2a79ef75e7abef6816e6367167f0c58ce2276570e07ee678eed5cda52603c" => :sierra
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
