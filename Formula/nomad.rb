class Nomad < Formula
  desc "Distributed, Highly Available, Datacenter-Aware Scheduler"
  homepage "https://www.nomadproject.io"
  url "https://github.com/hashicorp/nomad/archive/v1.2.6.tar.gz"
  sha256 "c69ec89ae5f76704d4b3ecb842b130f3d90e579bfd31191721b5f2da99f95a93"
  license "MPL-2.0"
  head "https://github.com/hashicorp/nomad.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e4a6bd71e877896b8a17432988803d119353f2467562e2f9b4d7ec0c3e59e9a8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a1049e029e65c7692e9ebb449458e26780d61705fdcd1e7a72f307af7a648e8d"
    sha256 cellar: :any_skip_relocation, monterey:       "87e730c6492037493416379f52556b918fe716ff1851587a0262952fa12f3fd7"
    sha256 cellar: :any_skip_relocation, big_sur:        "a37f398250614286552e4cfe2afe869e5cf2febfe7a658d23a84daad0274cf36"
    sha256 cellar: :any_skip_relocation, catalina:       "9dea96076cadb242db288d49c9ccc20530ed74a86ae7d6125472f06830f7562d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8fccbd6f43d5bd77182562de513a998fa79d7d76d8d44125cbdb86d759dd1159"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "-tags", "ui"
  end

  service do
    run [opt_bin/"nomad", "agent", "-dev"]
    keep_alive true
    working_dir var
    log_path var/"log/nomad.log"
    error_log_path var/"log/nomad.log"
  end

  test do
    pid = fork do
      exec "#{bin}/nomad", "agent", "-dev"
    end
    sleep 10
    ENV.append "NOMAD_ADDR", "http://127.0.0.1:4646"
    system "#{bin}/nomad", "node-status"
  ensure
    Process.kill("TERM", pid)
  end
end
