class Atlantis < Formula
  desc "Terraform Pull Request Automation tool"
  homepage "https://www.runatlantis.io/"
  url "https://github.com/runatlantis/atlantis/archive/v0.10.1.tar.gz"
  sha256 "98a1dae80acfa1c322007d4a2e29a28733edc386d74b9b3b07608fe64820a843"
  bottle do
    cellar :any_skip_relocation
    sha256 "6a7ecd37325d562a499a19b4080fd56bc19146e363e3c536538928b48dad11c0" => :catalina
    sha256 "c8dab2be57c47e361cbadc2b5e61d4292d6a440bc7adcfd03371e9510ca38625" => :mojave
    sha256 "a430e649cbb7b4780f875f874254444f59d9f5094be0761d1e8010c510f14525" => :high_sierra
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
