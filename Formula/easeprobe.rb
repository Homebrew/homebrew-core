class Easeprobe < Formula
  desc "Simple, standalone, and lightWeight tool that can do health/status checking"
  homepage "https://github.com/megaease/easeprobe"
  url "https://github.com/megaease/easeprobe.git",
      tag:      "v1.5.0",
      revision: "0a8646bbd05fdcd062e31fe8979abc488e13dec2"
  license "Apache-2.0"
  head "https://github.com/megaease/easeprobe.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "be6390f918832b7579cf84d847590ce67c8e6b69526e4f8f29cd64228f97e011"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "71dad2751a54a45cb5368e23af0a50928543fbfa930c1f8f6596ee4ab23369c1"
    sha256 cellar: :any_skip_relocation, monterey:       "c075618f0b40bb73d19a8b67faa449b6ca65e9e5176e24fec9910d2324ecdb98"
    sha256 cellar: :any_skip_relocation, big_sur:        "16c6664e884eec818c795693956eb5abf5bd43e4f437ecc7204e3db94dc5fddf"
    sha256 cellar: :any_skip_relocation, catalina:       "e3621278a747079d414ad62a96e5334c1fc36b22acdf19f30b4b29f2f2e8ceba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a45a320e3b25797ca6d24612ccbb55bcc703fd9847aa5d5bbfbf1dd3b0e70880"
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
