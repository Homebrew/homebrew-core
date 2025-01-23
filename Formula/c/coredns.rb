class Coredns < Formula
  desc "DNS server that chains plugins"
  homepage "https://coredns.io/"
  url "https://github.com/coredns/coredns/archive/refs/tags/v1.12.0.tar.gz"
  sha256 "71a585f7d41cd07a0839788bd3bb17bcc26501711c857eeae7cae2f1f654eeac"
  license "Apache-2.0"
  head "https://github.com/coredns/coredns.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "47e98345265be947d8eb69e60109b0c5b535f692d43e4ec9b26d2a898fea5fa8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6c2d80376e5c7ced1d827d68db8323403c3caf7779da4f68d294dfe218da4653"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "445eb9d1d7d1954be13d9d627ac524a281a2c395f19b48f88f3f6dc6739799c7"
    sha256 cellar: :any_skip_relocation, sonoma:        "416cba4b07cdd04de0fadab927cc1e37352d845e20790b60f6df33b45bf41f39"
    sha256 cellar: :any_skip_relocation, ventura:       "24f74e3e5580f6619ad9c570e607d7ae4ce2df25f084c04cbe43a194bfd3a5a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "49e825e0683e588c2aa18f28de5818412ea819d0e98319fa81e5fdf9d255d94f"
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
