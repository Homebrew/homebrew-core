class Easeprobe < Formula
  desc "Simple, standalone, and lightWeight tool that can do health/status checking"
  homepage "https://github.com/megaease/easeprobe"
  url "https://github.com/megaease/easeprobe.git",
      tag:      "v1.8.0",
      revision: "0108e6fc1a41607eef4f332ea05399ea59ce081e"
  license "Apache-2.0"
  head "https://github.com/megaease/easeprobe.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "81181c7323d36357bcfa63d9535dd098c697615ab7bd77fb66ea23159b8cf2ed"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "93d5914935e5fd11ddf12db56182f915071f381d98ccca52c4ec89f47a2d6346"
    sha256 cellar: :any_skip_relocation, monterey:       "daa7275f23e28d73aad539bd7ec9fb845d93b90b700873fca53e271c403674a0"
    sha256 cellar: :any_skip_relocation, big_sur:        "6d4c59e717e4257a92d4c3bd0866b86b90629aec2ac0cd9c163a35f518bf4817"
    sha256 cellar: :any_skip_relocation, catalina:       "ef85ce020d94b56b032bebf9e8bed5efc8bf699d3caa421fb928a49420b7d68c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8a8af55f6f4bd3860e9514b94815102f4a086dbe77423b669d9f7d1604f16481"
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
