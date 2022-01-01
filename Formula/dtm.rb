class Dtm < Formula
  desc "Cross-language distributed transaction manager"
  homepage "http://d.dtm.pub"
  url "https://github.com/dtm-labs/dtm/archive/refs/tags/v1.8.4.tar.gz"
  sha256 "a14f7c41582262709b67fef2e857a788c68b6af1630077cb882c7126c2d41159"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b430e4e760c116b740b3500ecec75553c4d2d2bb910231f43747329d6e1b6863"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "791d568650f65f3123da5d23d8cfa876401eb591a71042a79ac4f1b0338477b2"
    sha256 cellar: :any_skip_relocation, monterey:       "463f680270a13253af59203410067417b9c8352f8f2b155cf7c4ce843b08b1c0"
    sha256 cellar: :any_skip_relocation, big_sur:        "12f97624ea8d4b167ca30a6da20622d36385701704e32d8ffeee8888361d4bfd"
    sha256 cellar: :any_skip_relocation, catalina:       "4f02349809168abde7c7fe06f8423f612c436074a1b9e105e94aa498aab9b38e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0dd46df68250524222ec007700b8839c5f3e1ed02f5e4b966e7e90f08be014ae"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=v#{version}")
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"dtm-qs"), "qs/main.go"
  end

  test do
    assert_match "dtm version: v#{version}", shell_output("#{bin}/dtm -v")
    dtm_pid = fork do
      exec bin/"dtm"
    end
    # sleep to let dtm get its wits about it
    sleep 5
    assert_match "succeed", shell_output("#{bin}/dtm-qs 2>&1")
  ensure
    # clean up the dtm process before we leave
    Process.kill("HUP", dtm_pid)
  end
end
