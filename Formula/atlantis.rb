class Atlantis < Formula
  desc "Terraform Pull Request Automation tool"
  homepage "https://www.runatlantis.io/"
  url "https://github.com/runatlantis/atlantis/archive/v0.9.0.tar.gz"
  sha256 "ff3b8b38c59c54ff9ff2dfd0c53c69af5308a6c6f64f92d1c4ece87a7d35f1c6"
  bottle do
    cellar :any_skip_relocation
    sha256 "a3847caa6e3d3ca2e75ea11b3b33768c77a13e16f02ef086ad8dc9e3df1bf0ff" => :catalina
    sha256 "2ecb14619c287f84755169dc93e717b12821df7ea24fec9a6960361e360c481b" => :mojave
    sha256 "679f5cd00ccf005c615dac181a872fd4edf07e5bc901116cd2a0fe25fa39ed18" => :high_sierra
    sha256 "2f23a7d6cc16f93dc87a455da15e297ce490f7df859a49dd04bf855b3519511a" => :sierra
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
