class Nomad < Formula
  desc "Distributed, Highly Available, Datacenter-Aware Scheduler"
  homepage "https://www.nomadproject.io"
  url "https://github.com/hashicorp/nomad/archive/v1.1.3.tar.gz"
  sha256 "18eb2b7fcd4d32952546b3d8b052e755dedc4c63e36527404db6abdce01b197d"
  license "MPL-2.0"
  head "https://github.com/hashicorp/nomad.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4869ca6a1c58256e9c597b1f6193e6c9d28e987be9cbd535adf36ee95faf8289"
    sha256 cellar: :any_skip_relocation, big_sur:       "b10fb64023f9754f3c93a9c4c8fd2657562d44c652442c5b6ebe9a26b1c06388"
    sha256 cellar: :any_skip_relocation, catalina:      "7928157e8a54ffae14d49be20765ac297c932dc6b7a306e51da522d8d365bed8"
    sha256 cellar: :any_skip_relocation, mojave:        "e79bdbeff82fec317283b66f715a0026ad2d56ce2c744ea56322bce807dc47b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d544a13a8cc27525732f26e643f626bd59f4e712a88fd734fd93fd83a9623463"
  end

  depends_on "go" => :build

  # Support go 1.17, remove after next release
  patch do
    url "https://github.com/hashicorp/nomad/commit/5f5ec95282f4f3392562d1dd39d4f12cdbc72a82.patch?full_index=1"
    sha256 "4c757ca650b71878390b6aaea1823482ae8196e0afaca6e72f4b65a626eb4e09"
  end

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
