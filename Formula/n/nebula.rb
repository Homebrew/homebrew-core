class Nebula < Formula
  desc "Scalable overlay networking tool for connecting computers anywhere"
  homepage "https://github.com/slackhq/nebula"
  url "https://github.com/slackhq/nebula/archive/v1.7.2.tar.gz"
  sha256 "c4771ce6eb3e142f88f5f4c12443cfca140bf96b2746c74f9536bd1a362f3f88"
  license "MIT"
  head "https://github.com/slackhq/nebula.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e30c0cf05dbcb16a4a5820126dd105067974e3a82d786a07fd0e5b2f36fb8085"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e30c0cf05dbcb16a4a5820126dd105067974e3a82d786a07fd0e5b2f36fb8085"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e30c0cf05dbcb16a4a5820126dd105067974e3a82d786a07fd0e5b2f36fb8085"
    sha256 cellar: :any_skip_relocation, ventura:        "14919101e5f7d51d091463a83ab2adad69e808991fc6e957ff5c6b7e46f9d85c"
    sha256 cellar: :any_skip_relocation, monterey:       "14919101e5f7d51d091463a83ab2adad69e808991fc6e957ff5c6b7e46f9d85c"
    sha256 cellar: :any_skip_relocation, big_sur:        "14919101e5f7d51d091463a83ab2adad69e808991fc6e957ff5c6b7e46f9d85c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d0c8001ffac28e44610535a60fd5a3bca5b649850f2360a2fec2676f7b2255a0"
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
