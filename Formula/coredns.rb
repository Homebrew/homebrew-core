class Coredns < Formula
  desc "DNS server that chains plugins"
  homepage "https://coredns.io/"
  url "https://github.com/coredns/coredns/archive/v1.10.1.tar.gz"
  sha256 "f47186452e5f2925e2c71135669afd9e03b9b55831417d33d612ef2fa69924a7"
  license "Apache-2.0"
  head "https://github.com/coredns/coredns.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "90174107c61e9ce290ab14b954292a2fc8620a342debc09ee764d3dd37564a65"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ba15a73065ae027c910ae5f8ecc38879611abaacb7c2b8501783955a208c1882"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "949e84820bb33065bcc76c3bfe9c30b947d3a3bb0d644075d1c61cc622c647b7"
    sha256 cellar: :any_skip_relocation, ventura:        "8dd7bd8f6639c524c3578d169271ce5290bb0824615d57f1a26df97c31f160ac"
    sha256 cellar: :any_skip_relocation, monterey:       "19eb6ea8035710973836bec703f08a594d793d72a93af585172b01be924cb36f"
    sha256 cellar: :any_skip_relocation, big_sur:        "a4951058901e8ca332a831826e52dd64ff30f9996e1871bb24c23651df740bbf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c5dda235c5ce6012160636941ee9244319f65a60e9c18263a950c91078c6ba76"
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
