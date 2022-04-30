class Easeprobe < Formula
  desc "Simple, standalone, and lightWeight tool that can do health/status checking"
  homepage "https://github.com/megaease/easeprobe"
  url "https://github.com/megaease/easeprobe.git",
      tag:      "v1.4.0",
      revision: "8d7c5f749a0fe3d6073f3f010a538bf6ea4edb48"
  license "Apache-2.0"
  head "https://github.com/megaease/easeprobe.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "01ab7e9004a5a2f5cf4637f27c9ff11c4c94cd736c685a9eb01fb81693ab3c99"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fc78d1f43d63ce42ed1bb00a23ad974059fcc9ccda3ce6c3874db789d017df0a"
    sha256 cellar: :any_skip_relocation, monterey:       "b611fabb9873047cd2ecf996bdf3c94fd37db6f2fcb7b3cc476248631123e518"
    sha256 cellar: :any_skip_relocation, big_sur:        "78eb4d3d9967955f8584235588b675a4b90a449bf377294298d775ef0772e962"
    sha256 cellar: :any_skip_relocation, catalina:       "170c5b1eb202eaf01457fdd06f38c8f30f60f33108fcdf44c2feb15845454d8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "998ad8d82769297a78667c1ca90e5a130ac410143f063568bad5b1fa81909c09"
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
