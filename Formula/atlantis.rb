class Atlantis < Formula
  desc "Terraform Pull Request Automation tool"
  homepage "https://www.runatlantis.io/"
  url "https://github.com/runatlantis/atlantis/archive/v0.17.2.tar.gz"
  sha256 "7dcba88cbcad2f7830bbc4e42839593a912c5419f0e1d49796f2a7b27203cf3f"
  license "Apache-2.0"
  head "https://github.com/runatlantis/atlantis.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "34592b2c07eea9c65c835d5136f740e34b8cbcf8ca6866ea52460d0f7421274e"
    sha256 cellar: :any_skip_relocation, big_sur:       "acdb2f74b2514924567ba6987b3699f98a9ff0a51d9437c10bb7c104bdd074c2"
    sha256 cellar: :any_skip_relocation, catalina:      "72415d2f9a2c21f285d491bdfa7cb62175c78fdf3d7539182062d73640d391b1"
    sha256 cellar: :any_skip_relocation, mojave:        "fa399e5ef91bcc8ee236e70977153d457f26eaf816069fa36eda8e3e13e55f68"
  end

  depends_on "go" => :build
  depends_on "terraform"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system bin/"atlantis", "version"
    port = free_port
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
