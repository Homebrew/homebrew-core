class Atlantis < Formula
  desc "Terraform Pull Request Automation tool"
  homepage "https://www.runatlantis.io/"
  url "https://github.com/runatlantis/atlantis/archive/v0.19.1.tar.gz"
  sha256 "6a5ee821d17a34597788a2c921a0724fc7ddaafae8daf9245ccd87bc7146aace"
  license "Apache-2.0"
  head "https://github.com/runatlantis/atlantis.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f0beed30daeff2472f213081e214c7f407b0e5f3da7046dd375ba31e8dea28bc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a37f42336e5cd3d78698242cd11490a55b5f9e538eb088ba3e6a83ee4eeb2d0f"
    sha256 cellar: :any_skip_relocation, monterey:       "996a357225d97a4ddf3ef05cb75f95b379ff566ec429cd649d0ad6ac8a800a6a"
    sha256 cellar: :any_skip_relocation, big_sur:        "0c1c4358f5234a39b934010b9001c9a1062f44a61229f03dc9e4c60eaaf6a208"
    sha256 cellar: :any_skip_relocation, catalina:       "c1a488377255e9583fa91a413d29ec7a434d909a554b20fc8150e99fceed376f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "88c991003b07e4d98d5adb2b0f7c43e4e86dfb1420d5b8e20ccceb45830bea75"
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
