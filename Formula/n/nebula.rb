class Nebula < Formula
  desc "Scalable overlay networking tool for connecting computers anywhere"
  homepage "https://github.com/slackhq/nebula"
  url "https://github.com/slackhq/nebula/archive/refs/tags/v1.11.0.tar.gz"
  sha256 "d570e30a04e4e25fb1bddac6e131f26b325f7c5226c4961c6c37ef6f297d60a6"
  license "MIT"
  head "https://github.com/slackhq/nebula.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7db853812b7f745d64bfa566d03bb0eee45b3915e1fe7d5e33a51b11f43c88fc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7db853812b7f745d64bfa566d03bb0eee45b3915e1fe7d5e33a51b11f43c88fc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7db853812b7f745d64bfa566d03bb0eee45b3915e1fe7d5e33a51b11f43c88fc"
    sha256 cellar: :any_skip_relocation, sonoma:        "af617a61b5a4f6a67b00c8565cc1f030c99da0ef1a23be304b12f1ee5f613ae3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bdc02bfb5635d7694292c57e857c572e0139c65d89f92ccd99fc0f064eb06970"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1fcab803f717ccf287c6cca554db23960e77ba6170ee1bb6c33e0c7177f6572e"
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
