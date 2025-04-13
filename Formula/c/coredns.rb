class Coredns < Formula
  desc "DNS server that chains plugins"
  homepage "https://coredns.io/"
  url "https://github.com/coredns/coredns/archive/refs/tags/v1.12.1.tar.gz"
  sha256 "665b2096611b960572b40ad7e943e9c6cca58da5f3885e148868578b15fbf8ef"
  license "Apache-2.0"
  head "https://github.com/coredns/coredns.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "13b4abe628698282e6474e7f352cff18cfa611706ac0ae34281cf39f36f1317c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "82804867b48f245caffea96c5f26d477e045f4570cfda68839dcfddc495d70d3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e1eb3d98808f8adcdaf8cc174df49f9dffc9af6373fee36cc8af5cebdd5cfd0a"
    sha256 cellar: :any_skip_relocation, sonoma:        "f13021d45cb2c999f65ef26fc2deb4d4f98dd08b8e9abe857e779c1186943a30"
    sha256 cellar: :any_skip_relocation, ventura:       "9251bb323b4068f6479e5a006340915186f2229229751b46a7be13de1ac4738d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9c91f537282c51406ea94933fbbf9a71b774f1abbbdfda543f1de92f45422965"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b65b0b0462eb7793d8457e7fbfdabf62efb683c869ef14952988cd045e6f0b5a"
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
