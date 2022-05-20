class Nomad < Formula
  desc "Distributed, Highly Available, Datacenter-Aware Scheduler"
  homepage "https://www.nomadproject.io"
  url "https://github.com/hashicorp/nomad/archive/v1.3.0.tar.gz"
  sha256 "ce00994e1dbd89d0685237b6815322780e09c414fcc80b019e0d163ea1cb7ac0"
  license "MPL-2.0"
  head "https://github.com/hashicorp/nomad.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ca595290035eaf6fcaa9c2942cac3cca947ead43babaca9c91b6c35d310ac9f5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "747e21c5acad3ffa4b4bc23017ba1fa7e11492e21cecd12af4c3fa00f9f9bc99"
    sha256 cellar: :any_skip_relocation, monterey:       "be9291f579e7762abbe729dd5bd21eb0f12f6a2cd9341a9ce63378af95db41a9"
    sha256 cellar: :any_skip_relocation, big_sur:        "8ff7736be7d3ec1d2d47ba6a0496a9a2db9bde956267df3b68630050ba210366"
    sha256 cellar: :any_skip_relocation, catalina:       "2bce68968aa8383ec061f0bfc62895c2b2c76c6b6bd48a0677109f7c68e51ceb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "de709e7697a204bd38392d513650d6c54c7271e5c48430c1b65741ef33f40acc"
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
