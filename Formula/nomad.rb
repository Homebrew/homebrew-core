class Nomad < Formula
  desc "Distributed, Highly Available, Datacenter-Aware Scheduler"
  homepage "https://www.nomadproject.io"
  url "https://github.com/hashicorp/nomad/archive/v1.4.4.tar.gz"
  sha256 "22c74cdbcbb194130a8bc4c36faf34452bc11567f61f784c22103db3cb475c90"
  license "MPL-2.0"
  head "https://github.com/hashicorp/nomad.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "39616226cbb7e888ace63df10db2fc4004c85b4dd8cb471f21897b6515b84e72"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1cd276d5bedb8c41a353198d0eb71cc0d00f35452649ecd9375d7c66f6ec251c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d53c1c0399ec03a48700a3e15371abd3562df803ee9cbe7b5176ee90773b2a2a"
    sha256 cellar: :any_skip_relocation, ventura:        "677296c0de27fc062ff072c406bcf4ed95807b330434e4aeb677437cebf2281a"
    sha256 cellar: :any_skip_relocation, monterey:       "eed21b021fa202f991514fa62798b3d52e78b67e546ab4a0a4f4990637d35fab"
    sha256 cellar: :any_skip_relocation, big_sur:        "f60f5a24534b2f1bcfdf0de19053e30d2674d825e54315063930dc1262f5a4ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b5ed1abbba714221d504fd663a7087504281c929894aea1e2a1266d2a928a478"
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
