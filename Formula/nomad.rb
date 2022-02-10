class Nomad < Formula
  desc "Distributed, Highly Available, Datacenter-Aware Scheduler"
  homepage "https://www.nomadproject.io"
  url "https://github.com/hashicorp/nomad/archive/v1.2.6.tar.gz"
  sha256 "c69ec89ae5f76704d4b3ecb842b130f3d90e579bfd31191721b5f2da99f95a93"
  license "MPL-2.0"
  head "https://github.com/hashicorp/nomad.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "29e2ea40e18c76fb3725106e69b633521abf92956dce1a89560bef596ec7b40d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2d2103a2fddf2f831e59d8bf2372d1267f4050da81f7678b6ac7c8f57fb8b881"
    sha256 cellar: :any_skip_relocation, monterey:       "4d896fce781c20e5f0c71cbded30f37c09d54065c97398832ca064c25d70fecb"
    sha256 cellar: :any_skip_relocation, big_sur:        "37771f8c80b9703d31458af3ce4949e2835387069182b7381ceb65638bce10d2"
    sha256 cellar: :any_skip_relocation, catalina:       "899e46a622062983967396b4df82d7c358e556bc484706e259ecaf1a0549e2f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2b4473ea91a4fd4a8939512fc28965995c5a06f79a652e7676848d005d8bd91a"
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
