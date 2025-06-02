class Nebula < Formula
  desc "Scalable overlay networking tool for connecting computers anywhere"
  homepage "https://github.com/slackhq/nebula"
  url "https://github.com/slackhq/nebula/archive/refs/tags/v1.9.5.tar.gz"
  sha256 "5f7000e943cbe8cc7d7e2651ee2301121654fe1f51902f010ca908ac9ca0eede"
  license "MIT"
  head "https://github.com/slackhq/nebula.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9be5d6d3107b432e480fee5d8de763b7a635f8405e89dc18d03e2eb87280c519"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9be5d6d3107b432e480fee5d8de763b7a635f8405e89dc18d03e2eb87280c519"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9be5d6d3107b432e480fee5d8de763b7a635f8405e89dc18d03e2eb87280c519"
    sha256 cellar: :any_skip_relocation, sonoma:        "f99c5d8ee04af63d8b66d8621a7fdade99320a79d40c858e41ae9d63b3afbb07"
    sha256 cellar: :any_skip_relocation, ventura:       "f99c5d8ee04af63d8b66d8621a7fdade99320a79d40c858e41ae9d63b3afbb07"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "12e43169ea6e398f43373feead4749abe76ca79a4ecf0bc515527d625c8b6350"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "261454c498815640ce24b1e470de31ec0edc17a37818b07f08c7c3037cc8d716"
  end

  depends_on "go" => :build

  def install
    ENV["BUILD_NUMBER"] = version
    system "make", "service"
    bin.install "./nebula"
    bin.install "./nebula-cert"
  end

  service do
    run [opt_bin/"nebula", "-config", etc/"nebula/config.yml"]
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
