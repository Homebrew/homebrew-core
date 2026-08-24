class Kdash < Formula
  desc "Simple and fast dashboard for Kubernetes"
  homepage "https://kdash-rs.github.io/"
  url "https://github.com/kdash-rs/kdash/archive/refs/tags/v2.1.1.tar.gz"
  sha256 "a1cd1f43eeb93623a7a66cced9952da8b92bade03804f21acbd3283ea8bd749e"
  license "MIT"
  head "https://github.com/kdash-rs/kdash.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1e98f730211a8fdd7bdfb0747d78f7dc99a877dbd3a26ac6556c876f617a06de"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b637dccc9149bf2d6d8f73463a70d46613a295ebe6dddad3661ce59adeb343ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4e9d5737505b51b0a61fe1f53a78b8c323125f09830a8487da84dc2dd6b2f7b0"
    sha256 cellar: :any_skip_relocation, sonoma:        "70d65c2a112cb01e4bf18d6db696abe04ba8029a76ae7c3969d952e6075a3356"
    sha256 cellar: :any,                 arm64_linux:   "becb71c66d7abc2ff4b6fbf7e82dd06583750f1441c9b058de5a487e22d9db44"
    sha256 cellar: :any,                 x86_64_linux:  "d4206c108ce40a6f72f155f273e9c8c558f41fcce8c40647b817201b6ac027ea"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kdash --version")

    require "pty"
    output_log = (testpath/"output.log")
    r, w, pid = PTY.spawn("#{bin}/kdash", [:out, :err] => output_log.to_s)
    r.winsize = [80, 130]
    w.write "\e[80;130R"
    sleep 1
    r.close
    w.close
    output = output_log.read.gsub(%r{\e\[[\d;?]*[ -/]*[@-~]}, "")
    assert_match "Active Context", output
    assert_match "Resources", output
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
