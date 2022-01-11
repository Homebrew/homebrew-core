class Nebula < Formula
  desc "Scalable overlay networking tool for connecting computers anywhere"
  homepage "https://github.com/slackhq/nebula"
  url "https://github.com/slackhq/nebula/archive/v1.5.2.tar.gz"
  sha256 "391ac38161561690a65c0fa5ad65a2efb2d187323cc8ee84caa95fa24cb6c36a"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "73fca38859544c8961c7c633a61216942d8e28bc317616757418ed6f9d42f5d9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "73fca38859544c8961c7c633a61216942d8e28bc317616757418ed6f9d42f5d9"
    sha256 cellar: :any_skip_relocation, monterey:       "3062dbc1b1bb998fe479edab971aa765acb115d67722fadef68287700b69ea60"
    sha256 cellar: :any_skip_relocation, big_sur:        "3062dbc1b1bb998fe479edab971aa765acb115d67722fadef68287700b69ea60"
    sha256 cellar: :any_skip_relocation, catalina:       "3062dbc1b1bb998fe479edab971aa765acb115d67722fadef68287700b69ea60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3f77fc3a0eeab07fc1157cfaaa39bc4d95da85c19859ca54f6ccdc320d4b12fe"
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
