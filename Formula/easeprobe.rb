class Easeprobe < Formula
  desc "Simple, standalone, and lightWeight tool that can do health/status checking"
  homepage "https://github.com/megaease/easeprobe"
  url "https://github.com/megaease/easeprobe.git",
      tag:      "v1.7.0",
      revision: "76657de7c333a4b0e4699b6f5c82a2d4df3e005c"
  license "Apache-2.0"
  head "https://github.com/megaease/easeprobe.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "944bbee9e47b8c97aa7b145659d66fc41acd66deefcf5b50f57c26cf6054d9b3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e28aa085c9a4cbcaf71cc9843a13379fc43d5be38a4d0e55d3858e0694a6a2ed"
    sha256 cellar: :any_skip_relocation, monterey:       "94a745080507d9cdfffdfeb8d6665e7aa62dc88baabd31bc81dc3d9640041549"
    sha256 cellar: :any_skip_relocation, big_sur:        "be37740f427f5d52bbdb82898475fca5339b28ef46f8ec6b43887d07fa8bb96f"
    sha256 cellar: :any_skip_relocation, catalina:       "e9fefd271ddff75702894c1df52914da51dfef70be83871bc1e9a4fbc02ee66b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e2c34cb3cb9cda479777e974b2a556fed97de4fe480ee34eaa0c4f4595464a6f"
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
      notify:
        log:
          - name: "logfile"
            file: #{testpath}/easeprobe.log
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
