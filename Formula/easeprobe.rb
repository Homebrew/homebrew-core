class Easeprobe < Formula
  desc "Simple, standalone, and lightWeight tool that can do health/status checking"
  homepage "https://github.com/megaease/easeprobe"
  url "https://github.com/megaease/easeprobe.git",
      tag:      "v2.1.0",
      revision: "c4e27709607bd8dc4945df273ef274a8ecd569d2"
  license "Apache-2.0"
  head "https://github.com/megaease/easeprobe.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9bb97f44af5c03a97995ce7e514ea161749463a5e52d11bad2d3a6eab7e592e9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9bb97f44af5c03a97995ce7e514ea161749463a5e52d11bad2d3a6eab7e592e9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9bb97f44af5c03a97995ce7e514ea161749463a5e52d11bad2d3a6eab7e592e9"
    sha256 cellar: :any_skip_relocation, ventura:        "da22e6db84a51adf9150d7d73a33d8d1dfba2f8a6e5ed034766f0d464b5a29e1"
    sha256 cellar: :any_skip_relocation, monterey:       "da22e6db84a51adf9150d7d73a33d8d1dfba2f8a6e5ed034766f0d464b5a29e1"
    sha256 cellar: :any_skip_relocation, big_sur:        "da22e6db84a51adf9150d7d73a33d8d1dfba2f8a6e5ed034766f0d464b5a29e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6520fddcf5e30170e34c63f760e28eb962fdfad3fc9ab7e84de196a88287c7ca"
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
