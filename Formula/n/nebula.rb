class Nebula < Formula
  desc "Scalable overlay networking tool for connecting computers anywhere"
  homepage "https://github.com/slackhq/nebula"
  url "https://github.com/slackhq/nebula/archive/refs/tags/v1.8.1.tar.gz"
  sha256 "85c048b6d39296eeb8cf2d3324124d834011121383d0550662018190494d433e"
  license "MIT"
  head "https://github.com/slackhq/nebula.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "74c9f6ca9aff4880edbc8761a8f2513534600cbec2817a96f9543c1e674260dc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "74c9f6ca9aff4880edbc8761a8f2513534600cbec2817a96f9543c1e674260dc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "74c9f6ca9aff4880edbc8761a8f2513534600cbec2817a96f9543c1e674260dc"
    sha256 cellar: :any_skip_relocation, sonoma:         "ee7599d651f4343eeea8dcbefc05676ba1e387ccc10a60807b2a140af76e4ef2"
    sha256 cellar: :any_skip_relocation, ventura:        "ee7599d651f4343eeea8dcbefc05676ba1e387ccc10a60807b2a140af76e4ef2"
    sha256 cellar: :any_skip_relocation, monterey:       "ee7599d651f4343eeea8dcbefc05676ba1e387ccc10a60807b2a140af76e4ef2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "18ea1aae843dc03939bcf1426d1786ab481abf21ba34fc26c054cec0688ad664"
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
