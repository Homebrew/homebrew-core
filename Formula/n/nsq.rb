class Nsq < Formula
  desc "Realtime distributed messaging platform"
  homepage "https://nsq.io/"
  url "https://github.com/nsqio/nsq/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "c6289e295aaa40c8d9651de76e66bc9f23e7f5c40b1cc051ea5901965093e1f0"
  license "MIT"
  head "https://github.com/nsqio/nsq.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "b7075d5ab5ff5090f350c30db2215f62ae04e8ae77754178546817297f58c91e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "996305c886d786e601f5252e6a0d95845bb2160bf9f2a5c5fb27bf801f302d01"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "708b357c95856ee8d0598beb7db172ebdef492f6754cb7cbdd09db30772d6d46"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b7c87bebb10695f7411a2662c959cac3a4da39febcc2fd6b10b7600ca2325520"
    sha256 cellar: :any_skip_relocation, sonoma:         "0ec31e900f313d0c2b7a7a71a12e6264f43346cb53ce66bea885386dc3d301b9"
    sha256 cellar: :any_skip_relocation, ventura:        "1c7e5d999245a576a73ff684c2540c8c2dd0f4dd7e6f0e1d045f97b9099dde0b"
    sha256 cellar: :any_skip_relocation, monterey:       "1d2ae14197604c4964dd5341720da2ec45cf31437eb7d3db811b6ca84e578174"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5635d83fc8df021e37cbe8058e509361bc5323ef663f713fdc82d84f1844e597"
  end

  depends_on "go" => :build

  def install
    system "make", "DESTDIR=#{prefix}", "PREFIX=", "install"
  end

  def post_install
    (var/"log").mkpath
    (var/"nsq").mkpath
  end

  service do
    run [opt_bin/"nsqd", "-data-path=#{var}/nsq"]
    keep_alive true
    working_dir var/"nsq"
    log_path var/"log/nsqd.log"
    error_log_path var/"log/nsqd.error.log"
  end

  test do
    lookupd = fork do
      exec bin/"nsqlookupd"
    end
    sleep 2
    d = fork do
      exec bin/"nsqd", "--lookupd-tcp-address=127.0.0.1:4160"
    end
    sleep 2
    admin = fork do
      exec bin/"nsqadmin", "--lookupd-http-address=127.0.0.1:4161"
    end
    sleep 2
    to_file = fork do
      exec bin/"nsq_to_file", "--lookupd-http-address=127.0.0.1:4161",
                              "--output-dir=#{testpath}",
                              "--topic=test"
    end
    sleep 2
    system "curl", "-d", "hello", "http://127.0.0.1:4151/pub?topic=test"
    sleep 2
    dat = File.read(Dir["*.dat"].first)
    assert_match "test", dat
    assert_match version.to_s, dat
  ensure
    Process.kill(15, lookupd)
    Process.kill(15, d)
    Process.kill(15, admin)
    Process.kill(15, to_file)
    Process.wait lookupd
    Process.wait d
    Process.wait admin
    Process.wait to_file
  end
end
