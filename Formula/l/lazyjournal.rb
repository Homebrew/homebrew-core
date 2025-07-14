class Lazyjournal < Formula
  desc "TUI for logs from journalctl, file system, Docker, Podman and Kubernetes pods"
  homepage "https://github.com/Lifailon/lazyjournal"
  url "https://github.com/Lifailon/lazyjournal/archive/refs/tags/0.7.9.tar.gz"
  sha256 "e28bec9a54f890e4af0c3ffeab3c12727eb55f684573cb651e97594b46f17630"
  license "MIT"
  head "https://github.com/Lifailon/lazyjournal.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f28456a15494ee9fc38e5334a1bc0d45a70d38e6590bee25aabea7d1149e1f3d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f28456a15494ee9fc38e5334a1bc0d45a70d38e6590bee25aabea7d1149e1f3d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f28456a15494ee9fc38e5334a1bc0d45a70d38e6590bee25aabea7d1149e1f3d"
    sha256 cellar: :any_skip_relocation, sonoma:        "7d041d52711de7240ba194acd34231808905865f0d7ef5209a4e282be8478683"
    sha256 cellar: :any_skip_relocation, ventura:       "7d041d52711de7240ba194acd34231808905865f0d7ef5209a4e282be8478683"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "55bc927387eab58d957c6f775833d948eaed76c75518bbe61d0b9305e8688aaa"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.date=#{time.iso8601}
      -X main.buildSource=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lazyjournal --version")

    require "pty"
    PTY.spawn bin/"lazyjournal" do |_r, _w, pid|
      sleep 3
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
