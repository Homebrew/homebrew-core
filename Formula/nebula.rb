class Nebula < Formula
  desc "Scalable overlay networking tool for connecting computers anywhere"
  homepage "https://github.com/slackhq/nebula"
  url "https://github.com/slackhq/nebula/archive/v1.6.1.tar.gz"
  sha256 "9c343d998d2eab9473c3bf73d434b8a382d90b1f73095dd1114ecaf2e1c0970f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9221b0958b043ad31d19d62582bfa5e87c2c929cd93afc88dfbbb5ea152e2383"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9221b0958b043ad31d19d62582bfa5e87c2c929cd93afc88dfbbb5ea152e2383"
    sha256 cellar: :any_skip_relocation, monterey:       "4fe9ad97db34803d1f950d3b5a574139b3978e9fca493e305d3852752d38dcfc"
    sha256 cellar: :any_skip_relocation, big_sur:        "4fe9ad97db34803d1f950d3b5a574139b3978e9fca493e305d3852752d38dcfc"
    sha256 cellar: :any_skip_relocation, catalina:       "4fe9ad97db34803d1f950d3b5a574139b3978e9fca493e305d3852752d38dcfc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "df756d919c35f94f9fc8ed6080e908466b55dcb0b246478b329f613994867aa1"
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
