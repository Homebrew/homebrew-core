class Nsq < Formula
  desc "Realtime distributed messaging platform"
  homepage "https://nsq.io/"
  url "https://github.com/nsqio/nsq/archive/v1.2.1.tar.gz"
  sha256 "5fd252be4e9bf5bc0962e5b67ef5ec840895e73b1748fd0c1610fa4950cb9ee1"
  license "MIT"
  head "https://github.com/nsqio/nsq.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "00f88216761ea1bed39c94c68c67acf66fccc895e0b212e44867b86be41bfe40"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "30543659d3c5990aa86f08346feea09adc2c7f5a388418f0c8eaff486cf388ec"
    sha256 cellar: :any_skip_relocation, monterey:       "269501de2272e478c383ad7d71cee76c20c5191ff1f5cb25a69bf51364f5a980"
    sha256 cellar: :any_skip_relocation, big_sur:        "daaf9729cff4ae0e02895d2c1fd398c592ee89f25b195be732c71a4b33f4a617"
    sha256 cellar: :any_skip_relocation, catalina:       "533d1087999114a2a426dd589f4417d2b8cdb5a11b399a6004bca83f572aeb50"
    sha256 cellar: :any_skip_relocation, mojave:         "154ac16069cd16a07ae6ca9ae2e432b26f52b2f2e79b5041322cbd726f3d7462"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "53915ff129d853cb2b5622889c938a7fd5ce073b90b8bdea4dc503d84b336e15"
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
