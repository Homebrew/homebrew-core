class Easeprobe < Formula
  desc "Simple, standalone, and lightWeight tool that can do health/status checking"
  homepage "https://github.com/megaease/easeprobe"
  url "https://github.com/megaease/easeprobe.git",
      tag:      "v2.0.1",
      revision: "787b337a77186503092c238ea9600e20fdf8c50c"
  license "Apache-2.0"
  head "https://github.com/megaease/easeprobe.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ab7df1004a6fbfe2988ad730e7bb7d51d21fe0d3ea536aafc80cc12b37550c67"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "54bdfde14ea9fea0274644df8bbfe63f481584a979ecc7a616ca01bcc767e92f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "276ae30824b83d44e531a114bb1475b5c3528a483192823b7d6c4f0aa5e46345"
    sha256 cellar: :any_skip_relocation, ventura:        "6a661096756c4b496f9a509c094ecbbd362459f140f8efd933b92482a87e0ad5"
    sha256 cellar: :any_skip_relocation, monterey:       "fb33d13137839a028ae88c853a025b3f344b76892309b178049976953037c4b1"
    sha256 cellar: :any_skip_relocation, big_sur:        "d0da63ad87099e1d441d6cb5063ba049aa32a5f8b08fca9e51cd795e15b5528a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7338d935db5a9ed52667034699d2a9c65ec774a08f2624007b8e660e940c779b"
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
