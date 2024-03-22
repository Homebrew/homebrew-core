class Atlantis < Formula
  desc "Terraform Pull Request Automation tool"
  homepage "https://www.runatlantis.io/"
  url "https://github.com/runatlantis/atlantis/archive/refs/tags/v0.27.2.tar.gz"
  sha256 "e44a53d4fa43cdaa88a2e7734da2854a97b1b555a425ab26ac5787ef9f3d3076"
  license "Apache-2.0"
  head "https://github.com/runatlantis/atlantis.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "03f18543ffa7f1ccfeed76a38b13c8bc3218f4177c7c3935487d482e9c122981"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c4e856d2ef8ca41e50d0b6f845e684eb6b26399076555017038364ededeb5e3b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2f8672e9052c6021666946e881b588f6380c43b6d5c76eabe9edf3e649b283f8"
    sha256 cellar: :any_skip_relocation, sonoma:         "baa26ea2d94fd9155b7c51ec482e069a988c654cf64a5884450ad97eb0c415f1"
    sha256 cellar: :any_skip_relocation, ventura:        "f3d432b4802a41c67e17bb19bbfb1112f422d831ce1bfb3f1f3173ccb5b150c3"
    sha256 cellar: :any_skip_relocation, monterey:       "3e80390542278cb9ba1976f944dd4dd2fb05c6d3a2ccd1d6bc3ac878078a01d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "da6dccb69d6516c14fe3e0b73b3cd2901203e3f482f226dc6e30bb5b0cbb3f6b"
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
