class Nebula < Formula
  desc "Scalable overlay networking tool for connecting computers anywhere"
  homepage "https://github.com/slackhq/nebula"
  url "https://github.com/slackhq/nebula/archive/v1.6.1.tar.gz"
  sha256 "9c343d998d2eab9473c3bf73d434b8a382d90b1f73095dd1114ecaf2e1c0970f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "517ffdb0b67657c2e10f3f383031e000aa78f96b8e25041031bf388673974043"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "517ffdb0b67657c2e10f3f383031e000aa78f96b8e25041031bf388673974043"
    sha256 cellar: :any_skip_relocation, monterey:       "88a21a7022e6d3c28d3c1be689d264a40120da152fdba58c43321873fb3498dd"
    sha256 cellar: :any_skip_relocation, big_sur:        "88a21a7022e6d3c28d3c1be689d264a40120da152fdba58c43321873fb3498dd"
    sha256 cellar: :any_skip_relocation, catalina:       "88a21a7022e6d3c28d3c1be689d264a40120da152fdba58c43321873fb3498dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "988df3a71be7017a69bf6a52c1f64bb25e6a1b4c014a0dea702effc8b9c3f3d1"
  end

  depends_on "go" => :build

  def install
    ENV["BUILD_NUMBER"] = version
    system "make", "service"
    bin.install "./nebula"
    bin.install "./nebula-cert"
    prefix.install_metafiles
  end

  plist_options startup: true
  service do
    run [opt_bin/"nebula", "-config", etc/"nebula/config.yml"]
    keep_alive true
    log_path var/"log/nebula.log"
    error_log_path var/"log/nebula.log"
  end

  test do
    system "#{bin}/nebula-cert", "ca", "-name", "testorg"
    system "#{bin}/nebula-cert", "sign", "-name", "host", "-ip", "192.168.100.1/24"
    (testpath/"config.yml").write <<~EOS
      pki:
        ca: #{testpath}/ca.crt
        cert: #{testpath}/host.crt
        key: #{testpath}/host.key
    EOS
    system "#{bin}/nebula", "-test", "-config", "config.yml"
  end
end
