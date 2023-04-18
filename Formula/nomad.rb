class Nomad < Formula
  desc "Distributed, Highly Available, Datacenter-Aware Scheduler"
  homepage "https://www.nomadproject.io"
  url "https://github.com/hashicorp/nomad/archive/v1.5.3.tar.gz"
  sha256 "f974ee06ef47b4b2bdf1981466e3498b509242a56a1e8a813b2405182e04601b"
  license "MPL-2.0"
  head "https://github.com/hashicorp/nomad.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b5816c06ad084e6780c533660322c8b7117beb7b123c87d9a2ddccf93fefb446"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a4624e9ca5cf478cd8b6524c9f7910c47fd92fa7a3c3c696ab7ab2de7cd7a82f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9aebaa1f0270d4bfb70681a35fafc8c8e74d1071916048ad7167cc2e32a28481"
    sha256 cellar: :any_skip_relocation, ventura:        "e1526fd21474e7342c6176b6bc3a02449a652eb1e138e61a7018d75826377c07"
    sha256 cellar: :any_skip_relocation, monterey:       "52b285970a37cca7e25581591dcbcb9feb18d68f75853c90bd10c0cb0e54db46"
    sha256 cellar: :any_skip_relocation, big_sur:        "95a5bcb0ed3b0811647c3384517e95d4d24a276c16db1f65f23644ce72d361ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c9ef8c4a487383d32d1fd2c1ab24d49ff4df543e7305461865eb4c109a177b1"
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
