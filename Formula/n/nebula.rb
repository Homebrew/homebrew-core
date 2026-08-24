class Nebula < Formula
  desc "Scalable overlay networking tool for connecting computers anywhere"
  homepage "https://github.com/slackhq/nebula"
  url "https://github.com/slackhq/nebula/archive/refs/tags/v1.11.1.tar.gz"
  sha256 "bcd5f144aa7bbf06dc62bc64b1734b0f33759b2eb13798ce2d93f16d4afc0ac3"
  license "MIT"
  head "https://github.com/slackhq/nebula.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e8f5c8366bfb83134b0433889dd3c10a0dc77c3227221098c8bb2141dc14c4d9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e8f5c8366bfb83134b0433889dd3c10a0dc77c3227221098c8bb2141dc14c4d9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e8f5c8366bfb83134b0433889dd3c10a0dc77c3227221098c8bb2141dc14c4d9"
    sha256 cellar: :any_skip_relocation, sonoma:        "6b295ad0fe6efee4dca3025e89a3da5fb85700f305ed91640d37c8cc880f2160"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "722fc2a2bfc7d06342a0cb5effb8535996133cee99bfc852f96347c3270c7053"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0edb45ca078f56bda3021bbbc75dab173e97c73b4aa6440c8280519cf9e0b751"
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
