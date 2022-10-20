class Nomad < Formula
  desc "Distributed, Highly Available, Datacenter-Aware Scheduler"
  homepage "https://www.nomadproject.io"
  url "https://github.com/hashicorp/nomad/archive/v1.4.1.tar.gz"
  sha256 "4a62f324ca51381413630ec8fdbf98104e7a25171e6d85659f34296ed9b84cb3"
  license "MPL-2.0"
  head "https://github.com/hashicorp/nomad.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1c3af6d5800452f8bd8285f8f4b7e88de67b193cdc4919defdb730211b357b86"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d65fa1e7292e5c94c4cc75cdebe987555a5e50c371ea6e6067e8232f86b189ab"
    sha256 cellar: :any_skip_relocation, monterey:       "af5d4df922c83da8aafa5ba6bf1d692109687fb66a19f488878ad696ecc992d5"
    sha256 cellar: :any_skip_relocation, big_sur:        "2e54d8f622af5c5e8d208cbf792b43d3934a5b673387180329cf45e655140383"
    sha256 cellar: :any_skip_relocation, catalina:       "0238a5f21d90d12310e46efd0d018b815845848cdbde70f833caf3192abff86f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "69923167f94898f3e9689485fb2ba47153b6c8b468dfea9adaa11d333e0eeae3"
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
