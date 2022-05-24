class Easeprobe < Formula
  desc "Simple, standalone, and lightWeight tool that can do health/status checking"
  homepage "https://github.com/megaease/easeprobe"
  url "https://github.com/megaease/easeprobe.git",
      tag:      "v1.4.0",
      revision: "8d7c5f749a0fe3d6073f3f010a538bf6ea4edb48"
  license "Apache-2.0"
  head "https://github.com/megaease/easeprobe.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "65614a9f926fb9eeb6cdc07bcd5c152cd622c53c93b78904fc486bb88d8127c6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dcb076860023b6c2088c922f42029224a08520a707174179bf56a13df0c326b8"
    sha256 cellar: :any_skip_relocation, monterey:       "9f166bb0967b571b011c38ee69868a0db507452bf8cda1910e175a816d164fad"
    sha256 cellar: :any_skip_relocation, big_sur:        "286cb976a3e53b39e8a80118bd14938178162d53f2e31922444b3252933fad64"
    sha256 cellar: :any_skip_relocation, catalina:       "c0a635acd17029c4fec06987a2dbd7a197527fd6eafe5803fdd95c09c7a3242f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ae99766e9af864ac1a2886917a00c9343502afc1fa3cf87a57a8e7f87a20400"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/megaease/easeprobe/pkg/version.RELEASE=#{version}
      -X github.com/megaease/easeprobe/pkg/version.COMMIT=#{Utils.git_head}
      -X github.com/megaease/easeprobe/pkg/version.REPO=megaease/easeprobe
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/easeprobe"
  end

  test do
    (testpath/"config.yml").write <<~EOS.chomp
      http:
        - name: "brew.sh"
          url: "https://brew.sh"
    EOS

    easeprobe_stdout = (testpath/"easeprobe.log")

    pid = fork do
      $stdout.reopen(easeprobe_stdout)
      exec bin/"easeprobe", "-f", testpath/"config.yml"
    end
    sleep 2
    assert_match "Ready to monitor(http): brew.sh", easeprobe_stdout.read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
