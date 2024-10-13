class Nebula < Formula
  desc "Scalable overlay networking tool for connecting computers anywhere"
  homepage "https://github.com/slackhq/nebula"
  url "https://github.com/slackhq/nebula/archive/refs/tags/v1.9.4.tar.gz"
  sha256 "7feb8337a8ce791bb97211a70fddfc9cb936e2a9bfbb3bc8ac714c868da3fc86"
  license "MIT"
  head "https://github.com/slackhq/nebula.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "02628b6ec323eeaa31833f3561af8eba7679d57c082b8ab644f48e2937d2c28e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "02628b6ec323eeaa31833f3561af8eba7679d57c082b8ab644f48e2937d2c28e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "02628b6ec323eeaa31833f3561af8eba7679d57c082b8ab644f48e2937d2c28e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "02628b6ec323eeaa31833f3561af8eba7679d57c082b8ab644f48e2937d2c28e"
    sha256 cellar: :any_skip_relocation, sonoma:         "768c505ba1596f1973144647d81b7a4185315ec26fd1b00da632944d81580ced"
    sha256 cellar: :any_skip_relocation, ventura:        "768c505ba1596f1973144647d81b7a4185315ec26fd1b00da632944d81580ced"
    sha256 cellar: :any_skip_relocation, monterey:       "768c505ba1596f1973144647d81b7a4185315ec26fd1b00da632944d81580ced"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "901dc2cb116c094a96a28a2711da1791f9b2367365cfd7358464a79f2ae1ba24"
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
    (testpath/"config.yml").write <<~EOS
      pki:
        ca: #{testpath}/ca.crt
        cert: #{testpath}/host.crt
        key: #{testpath}/host.key
    EOS
    system bin/"nebula", "-test", "-config", "config.yml"
  end
end
