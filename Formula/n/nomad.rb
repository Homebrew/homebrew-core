class Nomad < Formula
  desc "Distributed, Highly Available, Datacenter-Aware Scheduler"
  homepage "https://www.nomadproject.io"
  # NOTE: Do not bump to v1.7.0+ as license changed to BUSL-1.1
  # https://github.com/hashicorp/nomad/pull/18187
  # https://github.com/hashicorp/nomad/pull/18218
  url "https://github.com/hashicorp/nomad/archive/v1.6.1.tar.gz"
  sha256 "dabd35cf10d7c632fc3dc337d53dca1875d803db6f2dd49c79e99f61bbab5d57"
  license "MPL-2.0"
  head "https://github.com/hashicorp/nomad.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "05e9e88091d2766beada1163b4f5bede072787d00edb6fd4b27a7bfc2eb723fd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0edd1d6f041a1e8520cbdd2f37cdd1ed3a6e0223f2b7dd31f2bdabb86a946286"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f09ff7f9ee24bd854ad955c37b7241e78ee423f0cd793123a2d85e33cb6fefe7"
    sha256 cellar: :any_skip_relocation, ventura:        "a22abb6fa37f7fab52bee17687ba5a4b4223bbac3dffe394a12a6551e924d760"
    sha256 cellar: :any_skip_relocation, monterey:       "8ff17826263534d060850399ff80224c78b22eb01c81548d1a2699989ee66cfe"
    sha256 cellar: :any_skip_relocation, big_sur:        "708fe9cca291483c8c95d5db2bd21636a55d4eda1a43a26a198ac56eb78a7d23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8028cc7cb9e1806352a7b74916278445d8b95be0217d941378856a9e5a389823"
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
