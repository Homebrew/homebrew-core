class Nomad < Formula
  desc "Distributed, Highly Available, Datacenter-Aware Scheduler"
  homepage "https://www.nomadproject.io"
  url "https://github.com/hashicorp/nomad/archive/v1.2.3.tar.gz"
  sha256 "36e074f34091043a2b5d115496f371fb9df048134f402bb5943e17bcb2f911ff"
  license "MPL-2.0"
  head "https://github.com/hashicorp/nomad.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8b47ea4306c0ca47c09586f57d46f3c1454857e0045b642855448ffbd15b877d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eb935a26aa5f30b103b013fbf0cfab7c4568510337bc23032cad031e073d28a6"
    sha256 cellar: :any_skip_relocation, monterey:       "b10470c39c66c52ce64cdd7597f91a1b5cb6d040f09539075dbd89c319e3096a"
    sha256 cellar: :any_skip_relocation, big_sur:        "5c15b82f6a13c7f6b7bb39ec28aadc9ace7a634e21d95f15e3be410c792c7b90"
    sha256 cellar: :any_skip_relocation, catalina:       "c1845f793c8ffb706b6d15f960a16b279e10687208de4870f43ab91a2b1d36a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba5c86924c1b79586f9d1a66ddb8c17efba1de0d0610f2a2e87c59d258ea7382"
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
