class Coredns < Formula
  desc "DNS server that chains plugins"
  homepage "https://coredns.io/"
  url "https://github.com/coredns/coredns/archive/refs/tags/v1.14.7.tar.gz"
  sha256 "c3ecdf3ebaba0c453e3dc62643548dbece09999d589513f25ca00ca4eca89423"
  license "Apache-2.0"
  head "https://github.com/coredns/coredns.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "81483a5cfa264bc825e9286c6601a5109e190e83418b82db3ef318c4faaea97f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bca96b9649106b121ec88eaf4e04ba3b31bc80a266665adde29a3157d30d5f71"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "18c6144b6e468da4ae0af6d42dc8d6c089ed92798a92b72ed191f1554e20181f"
    sha256 cellar: :any_skip_relocation, sonoma:        "edb16c4847ce18f512c460e811c3a00808c80fc8c91cedbfbb6b487c964dfe4d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "82c7cc1ff895e96075e04733efaaf5ea12fd222b950e76d708c78d055e1d23d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a18ec4aeeb31c8f272e5b4852df2f66130b6b7a466df235a2be694f5bdc72e3"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "bind" => :test # for `dig`
  end

  def install
    system "make"
    bin.install "coredns"
  end

  service do
    run [opt_bin/"coredns", "-conf", etc/"coredns/Corefile"]
    keep_alive true
    require_root true
    working_dir HOMEBREW_PREFIX
    log_path var/"log/coredns.log"
    error_log_path var/"log/coredns.log"
  end

  test do
    port = free_port
    spawn bin/"coredns", "-dns.port=#{port}"
    sleep(2)
    output = shell_output("dig @127.0.0.1 -p #{port} example.com.")
    assert_match(/example\.com\.\t\t0\tIN\tA\t127\.0\.0\.1\n/, output)
  end
end
