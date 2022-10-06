class Atlantis < Formula
  desc "Terraform Pull Request Automation tool"
  homepage "https://www.runatlantis.io/"
  url "https://github.com/runatlantis/atlantis/archive/v0.19.9.tar.gz"
  sha256 "98e1f0f6b721fd3744eb4213673e842388956fad36cab5d91906b9ec2464d8d7"
  license "Apache-2.0"
  head "https://github.com/runatlantis/atlantis.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "43dd16991f6bac05a0bb05db52c27f64a36a2aed987f9a7826a663921a5fb822"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fc50a0eb348c43ff20b5617481107f5039367207849254dac139a80ffdb98acd"
    sha256 cellar: :any_skip_relocation, monterey:       "feaef126eb624f4a14bf3512d29880c2239346bbe752f0ec2087824042182715"
    sha256 cellar: :any_skip_relocation, big_sur:        "123f85370b232a626dec386b642d793e446a94a01cb5935191e05af0fcf8aece"
    sha256 cellar: :any_skip_relocation, catalina:       "f8e169662b04a87beba6db56b667f475aa75e32a6dea1d7fb439a07ae3cc358a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "024d68349c5631a01f076ad6f2eb2d258b1ef32686ef795029b8458decc6acbb"
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
    gh_args = "--gh-user INVALID --gh-token INVALID --gh-webhook-secret INVALID --repo-allowlist INVALID"
    command = bin/"atlantis server --atlantis-url http://invalid/ --port #{port} #{gh_args} --log-level #{loglevel}"
    pid = Process.spawn(command)
    system "sleep", "5"
    output = `curl -vk# 'http://localhost:#{port}/' 2>&1`
    assert_match %r{HTTP/1.1 200 OK}m, output
    assert_match "atlantis", output
    Process.kill("TERM", pid)
  end
end
