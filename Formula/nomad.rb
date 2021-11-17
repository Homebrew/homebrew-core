class Nomad < Formula
  desc "Distributed, Highly Available, Datacenter-Aware Scheduler"
  homepage "https://www.nomadproject.io"
  url "https://github.com/hashicorp/nomad/archive/v1.2.0.tar.gz"
  sha256 "fb76938823ccf23f7afca39d177fa7385c69128e729f98cdeb6cd53a75c908df"
  license "MPL-2.0"
  head "https://github.com/hashicorp/nomad.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3e44da75bd6a2f46f27e4a90e3081369ce52b9bb6e50e01c339a8edd322a12c8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "803973b3d6ea0d1a17fe1f5d18b4e56af3a9512b97e31c670e252484d5aa1fb0"
    sha256 cellar: :any_skip_relocation, monterey:       "1f76cccf7783b8df076c154ca2012657ca8e38a7c4f12e754881b638f1f877b1"
    sha256 cellar: :any_skip_relocation, big_sur:        "3b5e8347c2a2da133a417a6c3dd5ed384b7d8787078d6fa5cff56e218ea8fa85"
    sha256 cellar: :any_skip_relocation, catalina:       "b76b0fb39972becc81039c06e0b0b54694d762ca847267ce690d6d0148b54b61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f1602c45dc198157459159b160bfa029c465197b12a0b997fa9fad7f6fd7ecc2"
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
