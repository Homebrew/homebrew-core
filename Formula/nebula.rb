class Nebula < Formula
  desc "Scalable overlay networking tool for connecting computers anywhere"
  homepage "https://github.com/slackhq/nebula"
  url "https://github.com/slackhq/nebula/archive/v1.4.0.tar.gz"
  sha256 "e8d79231f6100a2cd240d6a092d0dcc2bfccadffa83cb40e99b7328f6c75c2ec"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f7917a3ad415e2b258d46eeb8d477e1fe4b1116d57b988143652c0dc35407429"
    sha256 cellar: :any_skip_relocation, big_sur:       "e2e3d254fe289a4f2f23501f28ca166905faaf57db788e5ee315f4fc0bb4e0b5"
    sha256 cellar: :any_skip_relocation, catalina:      "ab02181a5aac3eeb36c11e1125e5076cf4b8a95d27da2aa08b1f75b47da80ce4"
    sha256 cellar: :any_skip_relocation, mojave:        "38f86a06ff08b5f28e3cce3d4509c12998d163977c6e99d38f897a3a28964381"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "005ffcc591656848e543d7c680fb52fc0e27fe6253413fc1294aa46c6cce446c"
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
