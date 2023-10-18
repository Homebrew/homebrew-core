class Easeprobe < Formula
  desc "Simple, standalone, and lightWeight tool that can do health/status checking"
  homepage "https://github.com/megaease/easeprobe"
  url "https://github.com/megaease/easeprobe.git",
      tag:      "v2.1.1",
      revision: "5b3a33c0eacafeffde0d38f9a65a0218468d5fb0"
  license "Apache-2.0"
  head "https://github.com/megaease/easeprobe.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "db40c79d44d902061406cadf9f76938cb59f9f605fc6b47dcef0b0b63ae98770"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "106f298416f1ea5f8ca9ec63dfa9c5f144f952eca9ed28f34ba7637dab45ee87"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "106f298416f1ea5f8ca9ec63dfa9c5f144f952eca9ed28f34ba7637dab45ee87"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "106f298416f1ea5f8ca9ec63dfa9c5f144f952eca9ed28f34ba7637dab45ee87"
    sha256 cellar: :any_skip_relocation, sonoma:         "8e516b118270bef24bd8be1b7c6c4f0d6921895ff5baf3c21341c0a35bafaf5e"
    sha256 cellar: :any_skip_relocation, ventura:        "91d8a4013fb1a8fb3b4d72cb3c4aecd8815d1c2ae72c7ed1425516f583bad9f4"
    sha256 cellar: :any_skip_relocation, monterey:       "91d8a4013fb1a8fb3b4d72cb3c4aecd8815d1c2ae72c7ed1425516f583bad9f4"
    sha256 cellar: :any_skip_relocation, big_sur:        "91d8a4013fb1a8fb3b4d72cb3c4aecd8815d1c2ae72c7ed1425516f583bad9f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fdad5aef27db513302c0364efce30fcfea5cca73a7247414d8f74cc00cb24431"
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
