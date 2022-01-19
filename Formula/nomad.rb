class Nomad < Formula
  desc "Distributed, Highly Available, Datacenter-Aware Scheduler"
  homepage "https://www.nomadproject.io"
  url "https://github.com/hashicorp/nomad/archive/v1.2.4.tar.gz"
  sha256 "f9f2eba618283238072d18c24a2bbb8835a37aa4ed58c8732db150514cb1481e"
  license "MPL-2.0"
  head "https://github.com/hashicorp/nomad.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9ced34a285f1f317e28e59809ad78b3151e4c10c114e53d50d783dc6b116cd90"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9fd655a91bfd0d20dd954b112af8ccf48bc0c336d7a54feb869f70c0070b181f"
    sha256 cellar: :any_skip_relocation, monterey:       "1096e7716f8a93d6071d71f74b053b4e3f39ab328627c06c0bc5139bbfe931c1"
    sha256 cellar: :any_skip_relocation, big_sur:        "47fbdb3ddedc8956077eb628dac4d4c19ab6f2d9882be13549366fc581c732c2"
    sha256 cellar: :any_skip_relocation, catalina:       "43c3f4e76a6a666cf083b38987068d91a1f4c9e0a1c8886a0e87a30914ea5687"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4b40387a36f755f2a1cff2b26937eae50ac99c8c801d745bf0c9f5b0cecd9e84"
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
