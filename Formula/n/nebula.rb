class Nebula < Formula
  desc "Scalable overlay networking tool for connecting computers anywhere"
  homepage "https://github.com/slackhq/nebula"
  url "https://github.com/slackhq/nebula/archive/refs/tags/v1.10.1.tar.gz"
  sha256 "43223baae6909f08ce369d1100b5098b8f77c39fc8ce736afc74bed9917db752"
  license "MIT"
  head "https://github.com/slackhq/nebula.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b5e6e9c3e0551978951d708530943c30bed942dfc749a31eec1acee0cbe581bb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b5e6e9c3e0551978951d708530943c30bed942dfc749a31eec1acee0cbe581bb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b5e6e9c3e0551978951d708530943c30bed942dfc749a31eec1acee0cbe581bb"
    sha256 cellar: :any_skip_relocation, sonoma:        "0ded694f1e5239a497c7160482bcf57adcdf3f7e7f1355862983396dc1608e8f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "446e1aa9252f4b1d46341e51d4a9818e9f771ddb66a1e37e054c889c76b056e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "84e385c5e9a2ab61986dc784e658e10a667e8d7c9acd60f692ecd953cafa8ce7"
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
