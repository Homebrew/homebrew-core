class Nomad < Formula
  desc "Distributed, Highly Available, Datacenter-Aware Scheduler"
  homepage "https://www.nomadproject.io"
  url "https://github.com/hashicorp/nomad/archive/v1.2.2.tar.gz"
  sha256 "0ffbcf50c398f87db5e4594979f50ea9450427aed442d890fd7dc726198c918d"
  license "MPL-2.0"
  head "https://github.com/hashicorp/nomad.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ea042eba1be737015604766769567d9a93106e89e22c1d5c8aeb22990294556d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2ef62bff455985b7a548337ce18c83f50d002221db084c7828666370e43db4ca"
    sha256 cellar: :any_skip_relocation, monterey:       "2855160db194595d7e31f14ce9b375f8a914483b5899a7c8e3c431f8bc8c0604"
    sha256 cellar: :any_skip_relocation, big_sur:        "e540afb28cb89deb60c3882e4642ce20cba8c6661f7885baa3c1892ffa8ab27c"
    sha256 cellar: :any_skip_relocation, catalina:       "91e4923e6eb698987335332bacf0f0c6d02d75527153f439e8a30ab40dd58a20"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d29fcecf24114beb0b3cc082b10bf791df271722cfaa1dc31aa3773b3c0cd526"
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
