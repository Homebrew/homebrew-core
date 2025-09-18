class Nebula < Formula
  desc "Scalable overlay networking tool for connecting computers anywhere"
  homepage "https://github.com/slackhq/nebula"
  url "https://github.com/slackhq/nebula/archive/refs/tags/v1.9.6.tar.gz"
  sha256 "cb0246ee02e03d84237f0a8e0daf6236ea65d299c275bcd4f2d324a66d1d738b"
  license "MIT"
  head "https://github.com/slackhq/nebula.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3d738fd69c42ab18ecc2a660f83c79bfb373ca7c81ef8b09ce462b7f0fc47b6f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e6f59a4f872d1473f2f7cf18926ab14b7d8bbccb5bb892e6c872c11a6b43ec21"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e6f59a4f872d1473f2f7cf18926ab14b7d8bbccb5bb892e6c872c11a6b43ec21"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e6f59a4f872d1473f2f7cf18926ab14b7d8bbccb5bb892e6c872c11a6b43ec21"
    sha256 cellar: :any_skip_relocation, sonoma:        "24965ddda6baddc380d6adf41afa33988b5114723016f1af555f822f5bd4d08d"
    sha256 cellar: :any_skip_relocation, ventura:       "24965ddda6baddc380d6adf41afa33988b5114723016f1af555f822f5bd4d08d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "55c9c2784a48e6e192efd609244aea588ae89c142ca68ddfc93b2c3b43c38025"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "06cc496be659b9958ef4368e2773e270a91a8be32ba41f9054471eba7b503be4"
  end

  depends_on "go" => :build

  def install
    ENV["BUILD_NUMBER"] = version
    system "make", "service"
    bin.install "./nebula"
    bin.install "./nebula-cert"
  end

  service do
    run [opt_bin/"nebula", "-config", etc/"nebula/"]
    keep_alive true
    require_root true
    log_path var/"log/nebula.log"
    error_log_path var/"log/nebula.log"
  end

  test do
    system bin/"nebula-cert", "ca", "-name", "testorg"
    system bin/"nebula-cert", "sign", "-name", "host", "-ip", "192.168.100.1/24"
    (testpath/"config.yml").write <<~YAML
      pki:
        ca: #{testpath}/ca.crt
        cert: #{testpath}/host.crt
        key: #{testpath}/host.key
    YAML
    system bin/"nebula", "-test", "-config", "config.yml"
  end
end
