class Easeprobe < Formula
  desc "Simple, standalone, and lightWeight tool that can do health/status checking"
  homepage "https://github.com/megaease/easeprobe"
  url "https://github.com/megaease/easeprobe.git",
      tag:      "v1.6.0",
      revision: "2f049eef2d4719f4c155a6cc14b6f49ba801cf47"
  license "Apache-2.0"
  head "https://github.com/megaease/easeprobe.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2c7d71714f2f2a2a1f031488709072489f8ae5b87682cc7be3eebc36a3ff60ec"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c3351e05338385e78266e99fa44a3a9d6ef6e788f0e08ed5202f87f22391b2d0"
    sha256 cellar: :any_skip_relocation, monterey:       "523dd3455c61e4ebe2390d65f03b95a3f56b461fc14532dbc4b992da56707670"
    sha256 cellar: :any_skip_relocation, big_sur:        "0c2c69e1f3deaf7e8279a712ede1ba47d2d4ee71ba36d681d7ccf48e8ba63d4c"
    sha256 cellar: :any_skip_relocation, catalina:       "2ccc65ea068a873cc4f6ce8f3da1f27f92375ed3fdffceb3e5e9bb37f50de06e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba40cacdfe8cb95f9a72c3836038ef09210c431be8a51872ef8574bf09d0cf3d"
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
