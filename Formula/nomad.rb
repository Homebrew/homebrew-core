class Nomad < Formula
  desc "Distributed, Highly Available, Datacenter-Aware Scheduler"
  homepage "https://www.nomadproject.io"
  url "https://github.com/hashicorp/nomad/archive/v1.1.4.tar.gz"
  sha256 "b5064c7453f24f7029707b6a9b1ca3000a4a99264ef06bdea3b3d2c387baaf6a"
  license "MPL-2.0"
  head "https://github.com/hashicorp/nomad.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "24c97212a30225373e2b540b1483c611449ec0a8c3267d19b2d94390beaef331"
    sha256 cellar: :any_skip_relocation, big_sur:       "dd3706ae0be742f69d7cf9a3800fa2afc0ca5287e83f31edb604e3f43b81f70e"
    sha256 cellar: :any_skip_relocation, catalina:      "a97f752a4f01e8fc40e85759e4e024f4f08b421ac678f9d3a7f9efa5661aa445"
    sha256 cellar: :any_skip_relocation, mojave:        "9b06e7280d7d08d5d2598e8652ef3fb7a25082a235b0337ec5ac5dd6322b8f23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e5240a2fa90f74995075d3908ef7bf58e74ff5aea3d8ef0cb89fef07643bcb3"
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
