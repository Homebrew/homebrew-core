class Easeprobe < Formula
  desc "Simple, standalone, and lightWeight tool that can do health/status checking"
  homepage "https://github.com/megaease/easeprobe"
  url "https://github.com/megaease/easeprobe/archive/refs/tags/v2.2.1.tar.gz"
  sha256 "d5ec2f1929549eefa1ca721aa26e0af8b8b1842eb810056fb06c4ba115951f3c"
  license "Apache-2.0"
  head "https://github.com/megaease/easeprobe.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "c1194062c717a8f4ac3324a2fd1734e2c72065a0c74b396525d517863e713efd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d05402e176f5744a8c7c53541ad45b2c80544d58db27dc253e49c1353047679e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d05402e176f5744a8c7c53541ad45b2c80544d58db27dc253e49c1353047679e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d05402e176f5744a8c7c53541ad45b2c80544d58db27dc253e49c1353047679e"
    sha256 cellar: :any_skip_relocation, sonoma:         "6f1903fcc06d21bfe7a57f1f0d8b92c59be1963076b0bb2a4b31a53660b6cc8d"
    sha256 cellar: :any_skip_relocation, ventura:        "6f1903fcc06d21bfe7a57f1f0d8b92c59be1963076b0bb2a4b31a53660b6cc8d"
    sha256 cellar: :any_skip_relocation, monterey:       "6f1903fcc06d21bfe7a57f1f0d8b92c59be1963076b0bb2a4b31a53660b6cc8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "51d897ef882abeece060be98d4cfd601ce1b7936c9c744c8414d4f277410c67f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/megaease/easeprobe/pkg/version.RELEASE=#{version}
      -X github.com/megaease/easeprobe/pkg/version.COMMIT=#{tap.user}
      -X github.com/megaease/easeprobe/pkg/version.REPO=megaease/easeprobe
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/easeprobe"
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
