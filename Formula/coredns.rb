class Coredns < Formula
  desc "DNS server that chains plugins"
  homepage "https://coredns.io/"
  url "https://github.com/coredns/coredns/archive/v1.10.0.tar.gz"
  sha256 "0fa6631899c0ae93d1b557add54fb18587a5c55627b177eb9f31cdfdf8677184"
  license "Apache-2.0"
  head "https://github.com/coredns/coredns.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "789ca382bc7bc114051d251bbe1f52ab0b1a34f97dad41a4e8f075c9b99987e4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7297b2db0b0b9605d83284b1003a11a3bda68369136cc71e25efcde8c6ec49a6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b3ad40a9e6831dd84070f672b08fc8bdb9e0e3b343cac3bc705acbd21a4f4715"
    sha256 cellar: :any_skip_relocation, ventura:        "3a912425aa5f7678bee06470dffad475ace691467e4cf61ff1d9b2180caf3da0"
    sha256 cellar: :any_skip_relocation, monterey:       "7e7bd62f170026084a26fe235a190fdc33d1f29d3514f4aa4e523f768edd2e08"
    sha256 cellar: :any_skip_relocation, big_sur:        "7517447ac64977764985ac74d1027e1a67b1e22798683e22551a80c5965ea441"
    sha256 cellar: :any_skip_relocation, catalina:       "85d0734f54404298d40a7fc80af544b7549c5e875c525cd03b2725061a671bdf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e05841208c8027e36e53d7e5d91fd609519f3e7305e5bee4afa85c73d15df72e"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "bind" => :test # for `dig`
  end

  def install
    system "make"
    bin.install "coredns"
  end

  plist_options startup: true

  service do
    run [opt_bin/"coredns", "-conf", etc/"coredns/Corefile"]
    keep_alive true
    working_dir HOMEBREW_PREFIX
    log_path var/"log/coredns.log"
    error_log_path var/"log/coredns.log"
  end

  test do
    port = free_port
    fork do
      exec bin/"coredns", "-dns.port=#{port}"
    end
    sleep(2)
    output = shell_output("dig @127.0.0.1 -p #{port} example.com.")
    assert_match(/example\.com\.\t\t0\tIN\tA\t127\.0\.0\.1\n/, output)
  end
end
