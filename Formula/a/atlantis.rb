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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "45e7370e0bb99a6b9ccbf53c350641b3d467547e74e5858c8c063212a883f69a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "34ec275a05f786edbd77999c821ccec5f92862b0f85f4398bcda00f8af855522"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7fede0c11c3daeb524c58bbf82fb7a4bd53354e7d6fa4406d3203c7c21c0d9be"
    sha256 cellar: :any_skip_relocation, sonoma:         "a4c83a067e1e64bd5ca523c8715405cc4e96addc8caaf744c0b2d9669094f392"
    sha256 cellar: :any_skip_relocation, ventura:        "3eca304ebaaa84b491a730205e047262848339dcd7c5c28bda221fbe9cdca154"
    sha256 cellar: :any_skip_relocation, monterey:       "7593cf74e4dc4007efae749ce7110d7a9dcb154a81d425a863a30f8ae12f0b5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8568cd1c7021b44978654ac63db80eaba9f8203a8602a1facb0ca6577b2584d2"
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
