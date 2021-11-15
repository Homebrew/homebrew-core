class Nebula < Formula
  desc "Scalable overlay networking tool for connecting computers anywhere"
  homepage "https://github.com/slackhq/nebula"
  url "https://github.com/slackhq/nebula/archive/v1.5.0.tar.gz"
  sha256 "f67684a8eba6da91de3601afc97567fddd0e198973bba950fcf15cded92cdc50"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e955bd38d760c7f66411a3432f6530889c35301c78a627a6e8df13d65231d0ce"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e955bd38d760c7f66411a3432f6530889c35301c78a627a6e8df13d65231d0ce"
    sha256 cellar: :any_skip_relocation, monterey:       "467b8e9d7393b316a9bf6534f77cfe6ebfe48a1277d1c461c590f75eacb5f506"
    sha256 cellar: :any_skip_relocation, big_sur:        "467b8e9d7393b316a9bf6534f77cfe6ebfe48a1277d1c461c590f75eacb5f506"
    sha256 cellar: :any_skip_relocation, catalina:       "467b8e9d7393b316a9bf6534f77cfe6ebfe48a1277d1c461c590f75eacb5f506"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5fc370039758afb61a206aa131ffb9a282b5fb1b32de43a21d15da5dbce68d3b"
  end

  depends_on "go" => :build

  def install
    ENV["BUILD_NUMBER"] = version
    system "make", "bin"
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
