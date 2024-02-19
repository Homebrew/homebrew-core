class Nebula < Formula
  desc "Scalable overlay networking tool for connecting computers anywhere"
  homepage "https://github.com/slackhq/nebula"
  url "https://github.com/slackhq/nebula/archive/refs/tags/v1.8.2.tar.gz"
  sha256 "203713c58d0ec8a10df2f605af791a77a33f825454911ac3a5313ced591547fd"
  license "MIT"
  head "https://github.com/slackhq/nebula.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "97c069d2558e559571828faefb949635ed65885760afaa9f7bf35b68605aa8f5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "97c069d2558e559571828faefb949635ed65885760afaa9f7bf35b68605aa8f5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "97c069d2558e559571828faefb949635ed65885760afaa9f7bf35b68605aa8f5"
    sha256 cellar: :any_skip_relocation, sonoma:         "dcc7f6d0fcbb525234dfe4658fab0fb918a6a525f06ff39fc27ee94ca2e3d243"
    sha256 cellar: :any_skip_relocation, ventura:        "dcc7f6d0fcbb525234dfe4658fab0fb918a6a525f06ff39fc27ee94ca2e3d243"
    sha256 cellar: :any_skip_relocation, monterey:       "dcc7f6d0fcbb525234dfe4658fab0fb918a6a525f06ff39fc27ee94ca2e3d243"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "128748bb848277bb6470ac199c258bb7e21c84cc0552c80bed4c44e3f2bcc4b8"
  end

  depends_on "go" => :build

  def install
    ENV["BUILD_NUMBER"] = version
    system "make", "service"
    bin.install "./nebula"
    bin.install "./nebula-cert"
    prefix.install_metafiles
  end

  service do
    run [opt_bin/"nebula", "-config", etc/"nebula/config.yml"]
    keep_alive true
    require_root true
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
