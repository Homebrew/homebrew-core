class Easeprobe < Formula
  desc "Simple, standalone, and lightWeight tool that can do health/status checking"
  homepage "https://github.com/megaease/easeprobe"
  url "https://github.com/megaease/easeprobe.git",
      tag:      "v1.1.0",
      revision: "593a5b714a9fe247c0c38e013dd72598590f0092"
  license "Apache-2.0"
  head "https://github.com/megaease/easeprobe.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3814745c0cfafad66c1c16a4ece8346241be07ebbae955b4be5db3a52f8f3ea8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "afde1e8d74946f9347e31c442c877d19ebb0697b7b7240151a5b2a35c1f625fe"
    sha256 cellar: :any_skip_relocation, monterey:       "b026c29a03d3274577da184ef0a3c52a4f549eda3a81cabecf0ee5f3de044cb2"
    sha256 cellar: :any_skip_relocation, big_sur:        "806a03ac0cc089db88a55951f6dae8a731f4941d0e4282bb7143eaa63074c30c"
    sha256 cellar: :any_skip_relocation, catalina:       "2836cee4c1c9a593f5274a492c3b2ef47881d9a8e9f7620b075063f35b52e001"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a90e9e240f1a0ff60033f2330fa93947d6adef2107c91a3e87f26695733fdf4f"
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
