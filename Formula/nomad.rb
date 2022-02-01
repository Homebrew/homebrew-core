class Nomad < Formula
  desc "Distributed, Highly Available, Datacenter-Aware Scheduler"
  homepage "https://www.nomadproject.io"
  url "https://github.com/hashicorp/nomad/archive/v1.2.5.tar.gz"
  sha256 "a147befa81bb0b5beb5a8155b1aa426a971cda32813118c6886a7b99153baa5e"
  license "MPL-2.0"
  head "https://github.com/hashicorp/nomad.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f5118e6256c051507e0287c4e860ee4fddaf110253661a0df931496108cc35e5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "304ec4dcbe6ce2c8315947d3a9c2734d6640b46bde5ac9972304d97ab7111196"
    sha256 cellar: :any_skip_relocation, monterey:       "da85bddba76b7d894aff1b12c9c2170249f06c2eb9e7e6473aec28b479fba5d7"
    sha256 cellar: :any_skip_relocation, big_sur:        "babbd730c2140b729484b0fffeb9fa1afa77710cf08836009fda328c4f38ca11"
    sha256 cellar: :any_skip_relocation, catalina:       "5d1f1b5afa207c2fda73f11dac65c76db87ec4413a2b59b79ad5c7317aef8794"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa77588ed151e840c2d1165088b8bbbe9f804fe976e46d417a44e8593fbffa95"
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
