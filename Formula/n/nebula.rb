class Nebula < Formula
  desc "Scalable overlay networking tool for connecting computers anywhere"
  homepage "https://github.com/slackhq/nebula"
  url "https://github.com/slackhq/nebula/archive/refs/tags/v1.9.3.tar.gz"
  sha256 "fa7982e5712a3399a04b232a7a1dd87f9dbddc4bbe43d6e712a3ff4704e21fe6"
  license "MIT"
  head "https://github.com/slackhq/nebula.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fc445753846aefbfa5c7805c4d6ffe2525a75b969b799f6482fbb519796d3918"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fc445753846aefbfa5c7805c4d6ffe2525a75b969b799f6482fbb519796d3918"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fc445753846aefbfa5c7805c4d6ffe2525a75b969b799f6482fbb519796d3918"
    sha256 cellar: :any_skip_relocation, sonoma:         "1d3f6cf109e833a308e483999d6141c4b710fa212610df1cf88dd18478dd01d4"
    sha256 cellar: :any_skip_relocation, ventura:        "1d3f6cf109e833a308e483999d6141c4b710fa212610df1cf88dd18478dd01d4"
    sha256 cellar: :any_skip_relocation, monterey:       "1d3f6cf109e833a308e483999d6141c4b710fa212610df1cf88dd18478dd01d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a0c56b56da0b9c6edfa89577cc7b80cc8069739e1e36f1e37f4906bb95fddf8"
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
