class Lazyjournal < Formula
  desc "TUI for logs from journalctl, file system, Docker, Podman and Kubernetes pods"
  homepage "https://github.com/Lifailon/lazyjournal"
  url "https://github.com/Lifailon/lazyjournal/archive/refs/tags/0.8.0.tar.gz"
  sha256 "4688f13414c7bd1ba3d4ea7383a03f09391e182f7702c8b007f4b1f0f50161f2"
  license "MIT"
  head "https://github.com/Lifailon/lazyjournal.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5c636ade778f79a9152a1856b9651fc5e1a68c70cc81639e9b47f1d562455699"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c2ac0322c208270caa261050d3d4e42cf7e0d1d786a7cbd73230de592b1f7673"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c2ac0322c208270caa261050d3d4e42cf7e0d1d786a7cbd73230de592b1f7673"
    sha256 cellar: :any_skip_relocation, sonoma:        "cf3c899f71268f7a9160ddaf27e23e23dd53bfd6ee11510029143e41f3f0bd9d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "274a93db942d3cda7d10c346ccb6a74353329a6ea07ad6ebb12cd5d06b6704ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c97f77d9110aae245ccc1778e20bfd9c59f573af6eb76426ede694b4136766f"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
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
