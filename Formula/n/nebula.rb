class Nebula < Formula
  desc "Scalable overlay networking tool for connecting computers anywhere"
  homepage "https://github.com/slackhq/nebula"
  url "https://github.com/slackhq/nebula/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "ae55b2ecd440ceaa4d9eb5376affb4315b72d4de3ec237a8cc6e8d597ff0e6d0"
  license "MIT"
  head "https://github.com/slackhq/nebula.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c94a935051e21ddb4f167bdc48753ac072ad107c167dd91f9f2ab43d0014c60b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "173128f8a10f35e8cd3c5f0f37dd353ed8bc26240c60e1a655679b222675ef18"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e3299f1dd7dcbd3fbfb58970cda8e7ea40f7bdf16aa4cc478778c8295ec1c90d"
    sha256 cellar: :any_skip_relocation, sonoma:         "222f57bfddebbddfb3ea5d859f7ad3a2399250f178de31e1e311f58893ec36dc"
    sha256 cellar: :any_skip_relocation, ventura:        "f0a53b5ea8749ef7fe766997210299ddb0489605def4cc5db1fbd8c829cd06a3"
    sha256 cellar: :any_skip_relocation, monterey:       "dceb828a58183274336a779f4e07b3639c604d8254b255e7c9cfcfb24cf20de0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e35d7f6e89530d43ffc641dea992cf679f6bfe66c0b8450316947455e0860964"
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
