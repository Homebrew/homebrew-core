class Atlantis < Formula
  desc "Terraform Pull Request Automation tool"
  homepage "https://www.runatlantis.io/"
  url "https://github.com/runatlantis/atlantis/archive/v0.8.2.tar.gz"
  sha256 "e9808239f272218dcf3e77ace9567ac2aea60dc7bc40e72f9031dfc77068e656"
  bottle do
    cellar :any_skip_relocation
    sha256 "4741a62ab71b3dfaea9179a02473f862053c4f70e420fe07af9ba2b1090fdd14" => :mojave
    sha256 "9ec735c2241e6ef1e0e06d567e561d368d81263b701cb6212e6eb9a670c742c2" => :high_sierra
    sha256 "1f4819870b0473b2508727ea0da9b3304291debbba2491b55a0e4a011c719c55" => :sierra
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
