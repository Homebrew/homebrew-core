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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "38923f5a6d3cef22718346dc526dfeaeba92f2a8821983b70e91430e0c98cc0a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3019ed3511c2d6cbe472bb0d61b29c61021f138badf079c7238630968247d9b9"
    sha256 cellar: :any_skip_relocation, monterey:       "98078a662bf5fd597b34ed3d770b29c57fff0a1f36836176f5d711c1f8679779"
    sha256 cellar: :any_skip_relocation, big_sur:        "939493db69ade43e0a95e8db3a53c3c4791f674769e08f471d5f1bc32b447d47"
    sha256 cellar: :any_skip_relocation, catalina:       "9974be6c403878ce0d59da6898f73e4c4568683aa20598c50d2a98a4fe971c88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ffaf72937fa46c1c6ed4c9a09180ec1a10ccaa8f6325739a84e728f296a78346"
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
