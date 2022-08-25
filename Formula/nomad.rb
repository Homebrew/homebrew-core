class Nomad < Formula
  desc "Distributed, Highly Available, Datacenter-Aware Scheduler"
  homepage "https://www.nomadproject.io"
  url "https://github.com/hashicorp/nomad/archive/v1.3.4.tar.gz"
  sha256 "3c61f1deaf903653c997415f422cbc2ad52949e4bb0ba41a373421287634f69e"
  license "MPL-2.0"
  head "https://github.com/hashicorp/nomad.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b1ed60f7cfe4f597a29e7ae31fc9713d129e094ab4a6d2063ac91ea6740a794c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b0586c0be39392c8d079fec6801e7fc994124b9330dc9d1fa00cfaf150ca09d2"
    sha256 cellar: :any_skip_relocation, monterey:       "f8efe9a192dd4331ce9afc8bcc314cdcc3a05427826eef8faf948b35e2689c83"
    sha256 cellar: :any_skip_relocation, big_sur:        "ca7cb79720d9548f7fa6acec7ddc7ac53c454353935987075d5a2fc8b612d646"
    sha256 cellar: :any_skip_relocation, catalina:       "34f80d82161960ce09396e843c4f176a21efdfae4fc6345c4d3829befbfc4609"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e2e71e5cdd130116a6a34a298efbbd17a2aa64607e5e2a88ab888d0e84906bbf"
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
