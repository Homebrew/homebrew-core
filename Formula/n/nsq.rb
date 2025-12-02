class Nsq < Formula
  desc "Realtime distributed messaging platform"
  homepage "https://nsq.io/"
  url "https://github.com/nsqio/nsq/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "c6289e295aaa40c8d9651de76e66bc9f23e7f5c40b1cc051ea5901965093e1f0"
  license "MIT"
  head "https://github.com/nsqio/nsq.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5a22f058697307ea3179db86098d939c2a0bab28729af92fc2237fa9ec46b843"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "164a08f1fe7e3007fddbb6f4111ed19863d08888501a00a7b0328234801636f7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f1248437269d3aa06758ad5e02fb3fd13bf6ab46f7296b39c80bf9cf02cb1cf6"
    sha256 cellar: :any_skip_relocation, sonoma:        "353cac603cccbd9e62920f680f8328b17cc02baa391a3665b03345bc90edb1e5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c88ffbec2368aae0d432ebb3cb2b7dbe08b654bbc0d86f842a0034b9afa9a74e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a5066cbc44a03c78e4604cd45f34ba5eefadc51e876f61a7af5814ccc095096d"
  end

  depends_on "go" => :build

  def install
    system "make", "DESTDIR=#{prefix}", "PREFIX=", "install"
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
