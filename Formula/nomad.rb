class Nomad < Formula
  desc "Distributed, Highly Available, Datacenter-Aware Scheduler"
  homepage "https://www.nomadproject.io"
  url "https://github.com/hashicorp/nomad/archive/v1.3.1.tar.gz"
  sha256 "55915cd6ff0433b4b6d41d1e023a96cf283c95cb4d55960329a0f77eef939485"
  license "MPL-2.0"
  head "https://github.com/hashicorp/nomad.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "430ff159e62574ea2c01f4f1a7334b34ac609737e64c675e36af100e5f822534"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ba1a9e0fdc47d4e800c7bc324f1acd4e838b292a51cc6a73290b7e3a524c5f08"
    sha256 cellar: :any_skip_relocation, monterey:       "0a03323d02b5dc797c2c6f29338757025dacffa73d94b3d018b2a0b73ab5300d"
    sha256 cellar: :any_skip_relocation, big_sur:        "5e8760536dbb7f698f99b2724319e3fcb60117206d525c6684d0a38a46daba53"
    sha256 cellar: :any_skip_relocation, catalina:       "1ad56272d0cd4750a50366dab750b0f9e50b7da0eeead3ef415c883f9fc6efbf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "24a36c1d3266ae64e11307a21d9128695d665c586a603eaa65c56b8dec399790"
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
