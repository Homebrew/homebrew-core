class Nebula < Formula
  desc "Scalable overlay networking tool for connecting computers anywhere"
  homepage "https://github.com/slackhq/nebula"
  url "https://github.com/slackhq/nebula/archive/refs/tags/v1.9.7.tar.gz"
  sha256 "b8ca239c6c728deadbb28927c5332e4abf0466121d76616827adbaabbba32d05"
  license "MIT"
  head "https://github.com/slackhq/nebula.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1b7c619883ab42fcf031ec5f6bf1a7c96e52d2ac8aec1eadfc749862e41b895d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1b7c619883ab42fcf031ec5f6bf1a7c96e52d2ac8aec1eadfc749862e41b895d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1b7c619883ab42fcf031ec5f6bf1a7c96e52d2ac8aec1eadfc749862e41b895d"
    sha256 cellar: :any_skip_relocation, sonoma:        "456c49fd3087c203a54e024aa8d10169e5cee7d864b78f81df1a27802dd4600e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cf15589487ab2990409221da4d1f511595659250521cbc3ea03cab26b94a61fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bee5ec6a0f9b66bc7da679659352076dc5681ab1f1503e5bc0754d7aea4b9c43"
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
