class Coredns < Formula
  desc "DNS server that chains plugins"
  homepage "https://coredns.io/"
  url "https://github.com/coredns/coredns/archive/refs/tags/v1.12.4.tar.gz"
  sha256 "39713a5bfd6fd1a2df1caa7a8296c4327e48c51e964c83d5fea4ed3a5ba4df9f"
  license "Apache-2.0"
  head "https://github.com/coredns/coredns.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cc748c498df91d1f57566ce40413690e9699cab4193bb01e3fed39d5eeb35b01"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e803de5cd5f209ad17297c9bb1948cddb9ca8988c5b9a08ed677da2a456a2c25"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6514d3437f033e1b8b7568227b1c6083828b91593067201d48a4edd786791340"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "07c0c6ce12f42238fcd92e2e366f5ddba6328064040f68cc792cac531f6b24dd"
    sha256 cellar: :any_skip_relocation, sonoma:        "687e82a85b5b1133ef325580b8481a9d6f641e09704b9b03c1efb654f66da6c6"
    sha256 cellar: :any_skip_relocation, ventura:       "007d095c0c0cf7db0cf9cd3796eb3d7003f2652bec3b8fdbeb3221a3dddf9024"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c0a325b1825f044ada7fe39b08ec408420455b798e1de12bba68a83c87e5b723"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf6e7811bdde66fa6aaa4bfa6ef2613554e56144552f79b1a507d574c047f44f"
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
    fork do
      exec bin/"coredns", "-dns.port=#{port}"
    end
    sleep(2)
    output = shell_output("dig @127.0.0.1 -p #{port} example.com.")
    assert_match(/example\.com\.\t\t0\tIN\tA\t127\.0\.0\.1\n/, output)
  end
end
