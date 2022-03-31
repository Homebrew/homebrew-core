class Easeprobe < Formula
  desc "Simple, standalone, and lightWeight tool that can do health/status checking"
  homepage "https://github.com/megaease/easeprobe"
  url "https://github.com/megaease/easeprobe.git",
      tag:      "v1.2.0",
      revision: "ed0988acb0a7581f8ae778048fd16843872e8882"
  license "Apache-2.0"
  head "https://github.com/megaease/easeprobe.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "105ac70297b69dd0ee0ed844dca855cb793aac76600dfaf6e853f4edb568d8e1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "34fb1319b277213ba30c63eaa0cca7c4343699c5e4a86a5f013779812db3d0f1"
    sha256 cellar: :any_skip_relocation, monterey:       "de34d750a84b3cb98433d714071ac5ea57e59f05417fe83d9e95ed3100d9823a"
    sha256 cellar: :any_skip_relocation, big_sur:        "35455491fcaf45bb14f41728b19daf6c85c191ce566f986940e936cc5e1ed458"
    sha256 cellar: :any_skip_relocation, catalina:       "b98fd8cf758c2fc6ed0adcf02158eddab5256807afc76de3ae90bcd486ad0ead"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "de43a0c1d4f80b2c6753c0979945889bb39660fc69c8258ff8d5e42cc9bce3aa"
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
