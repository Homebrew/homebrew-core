class Noti < Formula
  desc "Trigger notifications when a process completes"
  homepage "https://github.com/variadico/noti"
  url "https://github.com/variadico/noti/archive/3.6.0.tar.gz"
  sha256 "7ae07d93e33039fbbe29aa2ecd224ba311d08338f87dd8b45aae70fc459eb8a4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c2c8e81b60fbad78d0c3050ba5c6d2ca92ca999ee3c4496bfbfaad3a2a0f4c6f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4030645e54ca4c1c8978a4029c21213c0a19687849bb80e72495b94edbbcbf16"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "17bf78992c9af85a5ca68e63dde196cdb66ce71690a31de9d3dafa218e4c49aa"
    sha256 cellar: :any_skip_relocation, ventura:        "2e1507d0859fffad4e6b4b5a920f2cf4c3e9435802bec4c801a59c52c1e6d6aa"
    sha256 cellar: :any_skip_relocation, monterey:       "18bcb41a040e9e9723253246a151a1ad2bd9f9f03f1854683ffe41ff1f2e03b5"
    sha256 cellar: :any_skip_relocation, big_sur:        "e0c80fcde8f4539a3206045854750395bc300395523b63446df57abe22cf4187"
    sha256 cellar: :any_skip_relocation, catalina:       "25b7f723c3b55868ca27d253fb655e0165f8ba515242a75907294c87a521aed7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "258775f1024c641237b18515dd6ac2021a1a10a56210bdcfe3bb18f3b2546eb4"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/variadico/noti/internal/command.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "cmd/noti/main.go"
    man1.install "docs/man/dist/noti.1"
    man5.install "docs/man/dist/noti.yaml.5"
  end

  test do
    assert_match "noti version #{version}", shell_output("#{bin}/noti --version").chomp
    system bin/"noti", "-t", "Noti", "-m", "'Noti recipe installation test has finished.'"
  end
end
