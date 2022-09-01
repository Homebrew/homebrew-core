class Nomad < Formula
  desc "Distributed, Highly Available, Datacenter-Aware Scheduler"
  homepage "https://www.nomadproject.io"
  url "https://github.com/hashicorp/nomad/archive/v1.3.5.tar.gz"
  sha256 "79217b094831b0901dfe5ae9c03ff45ddde15ea02078a0fd07fabe2ff8867c83"
  license "MPL-2.0"
  head "https://github.com/hashicorp/nomad.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d48252c74a54d1bb79cd5b36f167ac617f0c8507a0678d40169e48e75b908ae2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9809dfb0723b8795a02ba6e66a2cb2dc986ad8f775c52263f9f58941934e29ac"
    sha256 cellar: :any_skip_relocation, monterey:       "7aec5e4a20596865c38a231db79be656d21f2a0dce3290bccc275fbf4135de5b"
    sha256 cellar: :any_skip_relocation, big_sur:        "c0c8cfc4d204f90776484b0948a97f85d57e7c3b0a64582f0f272084b346b5d2"
    sha256 cellar: :any_skip_relocation, catalina:       "94fa920547ec50e0ff288900e31f4fcc05a574196697ac8fb629be097cf1eb60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "416f54edfc3ed7bf7d1d0c3772e7e0d28be072ae7eccafbc62b3e4fc88bfea77"
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
