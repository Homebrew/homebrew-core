class Nebula < Formula
  desc "Scalable overlay networking tool for connecting computers anywhere"
  homepage "https://github.com/slackhq/nebula"
  url "https://github.com/slackhq/nebula/archive/v1.0.0.tar.gz"
  sha256 "e0585ef37fae1f8db18cdea20648d4087e586b20ff0961ab7eac59a6c9bdafa2"

  bottle do
    cellar :any_skip_relocation
    sha256 "fafd51b5bd0609e3f8e3b6e92a9e85f309b1ed6cea2e3342b0ffc4e691cb3823" => :catalina
    sha256 "e7a4dc91c7c1b8798468dfe977c6d365eea4a57b794aa94ab592edb005c5353d" => :mojave
    sha256 "99d660db7cd0f718b8bc9e876eb0a8e012c8c841f9b59b8d2b0fbe04374f47a7" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["BUILD_NUMBER"] = version
    system "make", "bin"
    bin.install "./nebula"
    bin.install "./nebula-cert"
    prefix.install_metafiles
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
