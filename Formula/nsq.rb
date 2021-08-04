class Nsq < Formula
  desc "Realtime distributed messaging platform"
  homepage "https://nsq.io/"
  url "https://github.com/nsqio/nsq/archive/v1.2.1.tar.gz"
  sha256 "5fd252be4e9bf5bc0962e5b67ef5ec840895e73b1748fd0c1610fa4950cb9ee1"
  license "MIT"
  head "https://github.com/nsqio/nsq.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8064f75c106ac7f5e38ce70dff06d018fa22a481e11d9c67dfac68231596bf9e"
    sha256 cellar: :any_skip_relocation, big_sur:       "e0ab534bb29ef8aa87ec70991763ec4b91e7c445e5ae980a992c7f0c392b17c2"
    sha256 cellar: :any_skip_relocation, catalina:      "9ec55f85df4dc5d5061faab19e8f8385518f5251aa53a72bc723a72123495bbb"
    sha256 cellar: :any_skip_relocation, mojave:        "c9fd1a756550b9bc325c1e8e88ddbc22da23d5a52cc0c11dd2669f5ec650ef90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ab9010a1df5113e0bb93211eda7033f5b9c528b517a2da61c99906b2a10af6e"
  end

  depends_on "go" => :build

  def install
    system "make", "DESTDIR=#{prefix}", "PREFIX=", "install"
    prefix.install_metafiles
  end

  def post_install
    (var/"log").mkpath
    (var/"nsq").mkpath
  end

  service do
    run [bin/"nsqd", "-data-path=#{var}/nsq"]
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
