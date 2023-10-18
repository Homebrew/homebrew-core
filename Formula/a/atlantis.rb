class Atlantis < Formula
  desc "Terraform Pull Request Automation tool"
  homepage "https://www.runatlantis.io/"
  url "https://github.com/runatlantis/atlantis/archive/v0.26.0.tar.gz"
  sha256 "5d303bd961af2ee317fcc0b5dedea3353fd8f995094b3d56882270253647fdc4"
  license "Apache-2.0"
  head "https://github.com/runatlantis/atlantis.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "36924081edab7c5bbd32b902c4ba3e126e983f0db71097e4ef36216d71ed7795"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2c2d5524a8e4e213ef26852852aa2842759ffd60cd7ee671db1f52b08970ba96"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8c6ba2ad10a8ae192c1041567df88373624006382e3e8d1fd7e8f9e475a6c543"
    sha256 cellar: :any_skip_relocation, sonoma:         "0d9f757ab890fa8e0a8421204798b7e1e8486be2abde34f6fc24e198293fb1a1"
    sha256 cellar: :any_skip_relocation, ventura:        "2126122023a0d38030353d74aa3abcb9e4df9292343513f9347116e86f21f831"
    sha256 cellar: :any_skip_relocation, monterey:       "21845d7a1c50068c9404f916a87cb8aee373814dc5f56d02a80b817b853be726"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "479c34f86198a7c7d3034322f658ed92a7cfe8a9bac2345781259d2379cd6198"
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
