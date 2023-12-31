class Atlantis < Formula
  desc "Terraform Pull Request Automation tool"
  homepage "https://www.runatlantis.io/"
  url "https://github.com/runatlantis/atlantis/archive/refs/tags/v0.27.0.tar.gz"
  sha256 "5f25e528710dc16f49d6596e2c37229caaa32bdefbc9795742dd12a800f4dd2d"
  license "Apache-2.0"
  head "https://github.com/runatlantis/atlantis.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b0eab1e02bb2b711d5ebd5c729791c7b634a8cbcab59f4a6594d5cd4d8defa9c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "32f0920a8c503b83044d7a6c874ebceb14fcf53bd131e2a293dbe4f84cc6d28f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c624b5cf9914beeb14a964cf033e411dc344157d87fdea86c07687f869ba1dce"
    sha256 cellar: :any_skip_relocation, sonoma:         "3aa19781edc71972a6273568aa59f35d4be587ff2aa53efddb7bcba8edc604d8"
    sha256 cellar: :any_skip_relocation, ventura:        "36faefd896505606021163d340e57e5be3c2f48a9e9ff91c6380c3375e44ef74"
    sha256 cellar: :any_skip_relocation, monterey:       "e88125dc0aaebd97d4872ae6b2541a8118d0f73d2761406b0e92b3dea1c611e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c55348126547a82ae3d0a7fa4eb7acb506dac684926fdb6308529caf66245836"
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
