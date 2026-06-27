class Nsq < Formula
  desc "Realtime distributed messaging platform"
  homepage "https://nsq.io/"
  url "https://github.com/nsqio/nsq/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "c6289e295aaa40c8d9651de76e66bc9f23e7f5c40b1cc051ea5901965093e1f0"
  license "MIT"
  head "https://github.com/nsqio/nsq.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "174c639dceac725941538d1b137001671ffdda041952e3f656d15e34d8655a8e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3f5d80fef901dbc92e4f9b37f37da27917e47f3d5447ee6cdfbffd4580fec614"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c928cf0c92aa4db6375e103c4180aa405584bb0c97fcf0557a05ca37f7700b72"
    sha256 cellar: :any_skip_relocation, sonoma:        "ad8054ad2253e25507210a0ba8790ca64726c5bd70c9b31334f0c72037d3425e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d33d9581089fdc927316c560b2c48425a9350bd46a8d2ba8f177310f5f108968"
    sha256 cellar: :any,                 x86_64_linux:  "b71120783261906d3cc8d386856616cbe17f172d5155c7a5ff59c90ac8454f87"
  end

  depends_on "go" => :build

  def install
    system "make", "DESTDIR=#{prefix}", "PREFIX=", "install"
  end

  service do
    run [opt_bin/"nsqd", "-data-path=#{var}/nsq"]
    keep_alive true
    working_dir var/"nsq"
    log_path var/"log/nsqd.log"
    error_log_path var/"log/nsqd.error.log"
  end

  test do
    lookupd = spawn bin/"nsqlookupd"
    sleep 2
    d = spawn bin/"nsqd", "--lookupd-tcp-address=127.0.0.1:4160"
    sleep 2
    admin = spawn bin/"nsqadmin", "--lookupd-http-address=127.0.0.1:4161"
    sleep 2
    to_file = spawn bin/"nsq_to_file", "--lookupd-http-address=127.0.0.1:4161",
                                       "--output-dir=#{testpath}",
                                       "--topic=test"
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
