class Nebula < Formula
  desc "Scalable overlay networking tool for connecting computers anywhere"
  homepage "https://github.com/slackhq/nebula"
  url "https://github.com/slackhq/nebula/archive/refs/tags/v1.9.6.tar.gz"
  sha256 "cb0246ee02e03d84237f0a8e0daf6236ea65d299c275bcd4f2d324a66d1d738b"
  license "MIT"
  head "https://github.com/slackhq/nebula.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9ea5bd56ad2d80258cd1c953579638bd57c792bf8718bdf1f3764d311debbe38"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9ea5bd56ad2d80258cd1c953579638bd57c792bf8718bdf1f3764d311debbe38"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9ea5bd56ad2d80258cd1c953579638bd57c792bf8718bdf1f3764d311debbe38"
    sha256 cellar: :any_skip_relocation, sonoma:        "ce40df53bf659aaf6c0a11e829566209a47b9e88034d9bb60153911475122118"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "485047208e47cf11bf919f48f7da6bde8d9cd2dc6119e711d552f84d70888417"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dff95a5f73806f67554cdef5fb8b2b380df586e5320235a7ad58ee24f878512d"
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
