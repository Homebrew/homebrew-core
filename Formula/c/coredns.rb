class Coredns < Formula
  desc "DNS server that chains plugins"
  homepage "https://coredns.io/"
  url "https://github.com/coredns/coredns/archive/refs/tags/v1.14.1.tar.gz"
  sha256 "ec814e2de304caaaabdbdc0c174e8f5e1668274d8c3da387d76cbb9b91faad66"
  license "Apache-2.0"
  head "https://github.com/coredns/coredns.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4cc382bccb03573529e724ba558311637188c44a096581caaf2186f94723748c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "12d21a321b6b64fe4b3ebacad7ad249ba57765ce796d21b1fc19d02e517fb145"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "900f0cb3957d2c685e6eba843b02b802fd0375bb6e03723f9eb0ebf30dba43e5"
    sha256 cellar: :any_skip_relocation, sonoma:        "e28357362fbee2e52cd240e7d2c4fe70aa0a7f0ecc541a5fe9f4d9013a29daa1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dbb9ba2274ec2e7b39eac7d6d1b92c0f30210e475448940045f14794a19245a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fcc63ea358a2b160f0a3bd295b315ff93865cd7063d212c5efc19ffe9b94126b"
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
