class Easeprobe < Formula
  desc "Simple, standalone, and lightWeight tool that can do health/status checking"
  homepage "https://github.com/megaease/easeprobe"
  url "https://github.com/megaease/easeprobe.git",
      tag:      "v1.9.0",
      revision: "92775df223eb2c64472a65f4d15528ebcda45bb6"
  license "Apache-2.0"
  head "https://github.com/megaease/easeprobe.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2e5db11e4e4563351d3e1dcff71148d79b71669a1009d60cdef984c8fd45dd9a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "beca54317110f9a30ebaa51d596805ab9d1413fc2ee168482816fa4316fa87de"
    sha256 cellar: :any_skip_relocation, monterey:       "1fc0a180638fa33306252c03e3328b3ca7b3374457f590e5d22dd8de7745e1e4"
    sha256 cellar: :any_skip_relocation, big_sur:        "ac6be7ad3ad9494cf106888e8f3a44398c750f1e4910b60e84be85157952542f"
    sha256 cellar: :any_skip_relocation, catalina:       "d34e9de29594ad7bcdc4f6109d44eb45218692c2af80b36e65ecd06ea8dc0251"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9a01f8809017b064939f5ddad590fd163e620ece477f100881f140083a732ed2"
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
