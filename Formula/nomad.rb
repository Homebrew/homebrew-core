class Nomad < Formula
  desc "Distributed, Highly Available, Datacenter-Aware Scheduler"
  homepage "https://www.nomadproject.io"
  url "https://github.com/hashicorp/nomad/archive/v1.5.1.tar.gz"
  sha256 "d1df280e400149e9bd41ee5e952201a06a2c8ab86554edc4d8d0f33fd2498e2f"
  license "MPL-2.0"
  head "https://github.com/hashicorp/nomad.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ea9ec42c80a055b39e57c364295bcf82c9589bf01a81c8510806931159b491d0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "86cf0ff40c406e619d1f8cb632c62e64576856b42178957f3658e0af7ea1fbec"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f54f75406e7bc7ff16eb9fc4098e5d8c737431d562088bb92e64f2b04e40b08c"
    sha256 cellar: :any_skip_relocation, ventura:        "1881e43604c4270ae5a98502060403e921991e05fdf65b983a54e63f8fff43a5"
    sha256 cellar: :any_skip_relocation, monterey:       "ccf6090977c8b7591e746b7f802c79123551816cb4653e81022bbc884dd753ce"
    sha256 cellar: :any_skip_relocation, big_sur:        "11c93668a6f4d61602d927ec6f899c65af65a97a5ac77137b6fc4473c6a85ecb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "044c549928584631182e873dd2f69da9115c01e5be4a9fb256d42dc5ba7da32b"
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
