class Easeprobe < Formula
  desc "Simple, standalone, and lightWeight tool that can do health/status checking"
  homepage "https://github.com/megaease/easeprobe"
  url "https://github.com/megaease/easeprobe/archive/refs/tags/v2.1.2.tar.gz"
  sha256 "e5372b2a29aa46d527b38aec39ea4cc9fc3f4b35712f9d5dff532924bfbc0db7"
  license "Apache-2.0"
  head "https://github.com/megaease/easeprobe.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c41da9c3e6e151f5991e4025adc3f15b5c80deca8a862f297324e3896bfc884b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "15320d1cf8cb8964c82c91e774f5fb737416622130686c6611bc559574d0a388"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9b5c5a3b106b23796925defabd6b891b32f9cd07e8044d867b0c0ae200f2897f"
    sha256 cellar: :any_skip_relocation, sonoma:         "35a9a229d960f2800730e63576bd1fb2ce0a57391d5e0a02943287f7dc2466b7"
    sha256 cellar: :any_skip_relocation, ventura:        "3f6f2d4d07d340ef17fdb94767f503b012ca76cf136902e2f36ae6fca1313e03"
    sha256 cellar: :any_skip_relocation, monterey:       "2ecc00215f4a97eba7328a8dc00779e1f464406cbe2a15ea1a28cac26f851312"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f072d4a9f3f7ffd5393cfc3220839ac8700b82462d9e068dfe22f9393f40f213"
  end

  depends_on "go" => :build

  # build patch to support go1.21 build
  # upstream pr ref, https://github.com/megaease/easeprobe/pull/471
  patch do
    url "https://github.com/megaease/easeprobe/commit/54a3a9aca42510ad2032f624ba9dff7e17b47e54.patch?full_index=1"
    sha256 "aeac6dfe643556d763b2d206c958385482c62fef3d1556d704bc93a52ea8ddbf"
  end

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
