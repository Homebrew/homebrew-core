class Coredns < Formula
  desc "DNS server that chains plugins"
  homepage "https://coredns.io/"
  url "https://github.com/coredns/coredns/archive/refs/tags/v1.14.4.tar.gz"
  sha256 "f9630172269b7e2afed73ae27e2701e4c0f1353ad3ab38385c27c766c489b015"
  license "Apache-2.0"
  head "https://github.com/coredns/coredns.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6c9bf16770fcaa996076e10ca6528d08735ba15c16245a5ccbddd59a3218e808"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "55cffd150506ae35d851b6deff4388fea054efaf68018a8a88500e02a886877e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "15dc59d785c3d80732f67385e248c082c8dd139221bc3fb83efb8daba768bcb8"
    sha256 cellar: :any_skip_relocation, sonoma:        "713eb5eacbd670ca2a091011d019ab9e31174828afc9297506f71d8f5b9251b6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d2387359a31419388575a363e5d77e4db25079947f3250af56e8ede0073f6acd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "357f1d03b8458bf71de6d77c3c45f1b499737b542f2afb5f7b6cb80420bb5c88"
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
