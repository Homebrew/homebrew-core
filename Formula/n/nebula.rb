class Nebula < Formula
  desc "Scalable overlay networking tool for connecting computers anywhere"
  homepage "https://github.com/slackhq/nebula"
  url "https://github.com/slackhq/nebula/archive/refs/tags/v1.10.0.tar.gz"
  sha256 "df36828f7cbf255a17891c8922f3fe654d553748ed41691e967743e495caa1bf"
  license "MIT"
  head "https://github.com/slackhq/nebula.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7370de2917e22f06597d75233711cc26949fc95998cfab8c76fdaa56cddc1127"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7370de2917e22f06597d75233711cc26949fc95998cfab8c76fdaa56cddc1127"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7370de2917e22f06597d75233711cc26949fc95998cfab8c76fdaa56cddc1127"
    sha256 cellar: :any_skip_relocation, sonoma:        "c7acfcf8b6506f0a6550283fd7ff8bd76f78f5349f3e3b58a52149411aef58d7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "59d07d7faac0b116a560e2a81db64b7004c8fa62f8d750709063fbf1b45f8725"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1546b1c3c1ab341615f9cf787e81ed04997677c487fd85ed59b0bfe7253b5f93"
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
