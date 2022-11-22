class Nomad < Formula
  desc "Distributed, Highly Available, Datacenter-Aware Scheduler"
  homepage "https://www.nomadproject.io"
  url "https://github.com/hashicorp/nomad/archive/v1.4.3.tar.gz"
  sha256 "0710f6bd787ed6fc98003ce63f5b7b44ae6b6672757f5638812af4ca1bca56fc"
  license "MPL-2.0"
  head "https://github.com/hashicorp/nomad.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "36e5297490a14b3970dc9e085ad47c2ceac228397a4ec3a8f8b3e456f9905ca9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a2816dc80261f89cb2d0937c6649c45130367201c2cd94e1c7edcd6895078b4e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "53202b4844e2c96d5cee060a0ad116df3ddec4f41740f1bf2468193d0d2e364d"
    sha256 cellar: :any_skip_relocation, ventura:        "b113e89063faff33603c0609af5c4de443e5cfc2512a8b53c7b36d2bfac1c7d9"
    sha256 cellar: :any_skip_relocation, monterey:       "a0a7268cde875b249db62ca893b5ac07d105e0e342aa1317043279a2b3ac555b"
    sha256 cellar: :any_skip_relocation, big_sur:        "c6305f71c83a9fe12da89e8451d90b2829dd49eae8b373e421237f72725853e0"
    sha256 cellar: :any_skip_relocation, catalina:       "567bb893593047d4131757d41896175fe4aef4d155c08358d9050c4ac8b0cff0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "122b26bb08f5fd335fb7c45c4a6a9f537b26f579eca5026e11cf5eb33684f943"
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
