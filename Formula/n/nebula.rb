class Nebula < Formula
  desc "Scalable overlay networking tool for connecting computers anywhere"
  homepage "https://github.com/slackhq/nebula"
  url "https://github.com/slackhq/nebula/archive/refs/tags/v1.10.3.tar.gz"
  sha256 "12972f5a1dc37b89dff6af91685f7f7eb643b7f75da760c036d1e8d850387e54"
  license "MIT"
  head "https://github.com/slackhq/nebula.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cbcbf92df4cd5074d7436121cbe41427c49442ec460c1d6525d1a982bf834ce1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cbcbf92df4cd5074d7436121cbe41427c49442ec460c1d6525d1a982bf834ce1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cbcbf92df4cd5074d7436121cbe41427c49442ec460c1d6525d1a982bf834ce1"
    sha256 cellar: :any_skip_relocation, sonoma:        "5fd259f54695506a796a449eaf67fbd1add757137f1f28f163d3cd040b91e2c2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ab93ebe3981b35e264fbb4a38f01a17ad5232ab8de894b735a137f3260f96051"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "40b31d951db63e1c0f916363782ca95f0ec73d9291cb67f19c45d94465dcd93a"
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
