class Lazyjournal < Formula
  desc "TUI for logs from journalctl, file system, Docker, Podman and Kubernetes pods"
  homepage "https://github.com/Lifailon/lazyjournal"
  url "https://github.com/Lifailon/lazyjournal/archive/refs/tags/0.8.6.tar.gz"
  sha256 "5798b65c98ec00f32cf43e79b31568896084881adb3afc9e7cda3482baad3183"
  license "MIT"
  head "https://github.com/Lifailon/lazyjournal.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fc3854e1d56aaf15091d83f1f8a9b89f0f2f173aa703c6dd09794b256e575438"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fc3854e1d56aaf15091d83f1f8a9b89f0f2f173aa703c6dd09794b256e575438"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fc3854e1d56aaf15091d83f1f8a9b89f0f2f173aa703c6dd09794b256e575438"
    sha256 cellar: :any_skip_relocation, sonoma:        "1d0c07938cc6b7494b391866cd19bb5c4ed517606d6a94838ad512f313c16d08"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "67560e02468fd739c3ef8afca68140791224cf227688e209a5c198f058367601"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b98e4072660bf9c11098e923546706cde607e9ddc7eb1939e41123469ef2f0e7"
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
