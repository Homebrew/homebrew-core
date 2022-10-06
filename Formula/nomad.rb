class Nomad < Formula
  desc "Distributed, Highly Available, Datacenter-Aware Scheduler"
  homepage "https://www.nomadproject.io"
  url "https://github.com/hashicorp/nomad/archive/v1.4.0.tar.gz"
  sha256 "e79fe16c8fa94231bc9e1a1ae93926343e16f0892112fc84e95e014ac56dcb6b"
  license "MPL-2.0"
  head "https://github.com/hashicorp/nomad.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8f22c207c370634b164716fa446905e63ef5e91af5b14a3905a7e8ca668d9860"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "30166147cd9e30a03b321658c36f9b3ac494ec8b496fcc051a39a1016678c8ab"
    sha256 cellar: :any_skip_relocation, monterey:       "bb96021806f098773d950c0aeb8677fd313723d54d59e64a2a672c78697127a1"
    sha256 cellar: :any_skip_relocation, big_sur:        "7f73ea0af78eaa823b334dbefd09f33a805169e9811ea6af42811997e77af75c"
    sha256 cellar: :any_skip_relocation, catalina:       "6b0e605ec1e6a5dba4d3b58a2663e5bd81b681b0e61e7c45cbbaacedba06b192"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "21dd66ddd628ff095aaf567ff897a89d133fdd65e91b82bcd71d7dd688497eb0"
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
