class Kubetui < Formula
  desc "TUI tool for monitoring and exploration of Kubernetes resources"
  homepage "https://github.com/sarub0b0/kubetui"
  url "https://github.com/sarub0b0/kubetui/archive/refs/tags/v1.10.1.tar.gz"
  sha256 "23d7273a67276670422d014cde1f0f3f2901bc5520274e51a83a943e8dabeaa9"
  license "MIT"
  head "https://github.com/sarub0b0/kubetui.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0c10a209f477563c4cfcbfb59825ff28de0bb18cf0e0e1d678830d9bfc89fd34"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "82457d58e47a7fa2ff42b367d86139d172df7a0f117cfcee19a89dbde915867c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4cee20e2e95f18bed0629e831c60b950255e6af550c721e228b5f630a60cc087"
    sha256 cellar: :any_skip_relocation, sonoma:        "6aba2676bc012787fb2a662e98064dfa2a49fd70b8e48505b7fc6063729c6250"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5e411da1f0eb50c01c95789f79659145bbdb8a37c8ca892c9e98fd08a1675108"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f84306ca92d059310550118967fc0d0e9a27170199a65eacaa4aaf65f492281"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kubetui --version")

    # Use pty because it fails with this error in Linux CI:
    #   failed to enable raw mode: Os { code: 6, kind: Uncategorized, message: "No such device or address" }
    r, _w, pid = PTY.spawn("#{bin}/kubetui --kubeconfig not_exist")

    output = ""
    begin
      r.each_line { |line| output += line }
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    ensure
      Process.wait(pid)
    end

    assert_match "failed to read kubeconfig", output
    assert_equal 1, $CHILD_STATUS.exitstatus
  end
end
