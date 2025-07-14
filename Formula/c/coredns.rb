class Coredns < Formula
  desc "DNS server that chains plugins"
  homepage "https://coredns.io/"
  url "https://github.com/coredns/coredns/archive/refs/tags/v1.12.2.tar.gz"
  sha256 "72599bcd11ec1fea7521f829d4b431144eb41112d145ce9805ef659e105c4195"
  license "Apache-2.0"
  head "https://github.com/coredns/coredns.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2d985b8bc038800b2f9ac5d07c89bdfdf0b718ccea50a214927f0585f30f02c6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e9ae4a56dcf6ac34ae6e2bd66233ac372ac79a9e13716c5583e6394e3f0857de"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c23deef6517e1719b89c2537866ab5fc76c0fc0276f16e527aa40bf339712548"
    sha256 cellar: :any_skip_relocation, sonoma:        "e8dc8864cb4352dda93a7e67f2a5affed7c71a3fb5ef2bb174e60042fd71159b"
    sha256 cellar: :any_skip_relocation, ventura:       "fed71f0e5c8a0a2f65b51777e462c462ae9831db780939c466510c35377fed42"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d947de41aacc6b0f2b202cfacf156c0440472ff3e3fbf6130e602b5cace8379b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a76a4f4ae8b22c549b0a64b027de0cb3b5a46cafbff8dc324cf664cd111c3abb"
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
