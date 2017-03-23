class Nsq < Formula
  desc "Realtime distributed messaging platform"
  homepage "http://nsq.io"
  url "https://github.com/nsqio/nsq/archive/v1.0.0-compat.tar.gz"
  version "1.0.0"
  sha256 "c279d339eceb84cad09e2c2bc21e069e37988d0f6b7343d77238374081c9fd29"
  head "https://github.com/nsqio/nsq.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "160e7e8b45f7989ac8d6606a58fb97022287b219197e94e3a56df7c0bf8b23b3" => :sierra
    sha256 "a47078542e18ded524af3072f7311175012611dd5f39fbfcc4b42d33e1e96ac7" => :el_capitan
    sha256 "c1de144a1b744bef456c9ac933e57d6c5dfc0779351955f23e70120cbff3d8de" => :yosemite
    sha256 "c2429649bf69d28e46d6a616c14dff1231b54791d82e8e847fd361f2907ac0d0" => :mavericks
  end

  depends_on "go" => :build
  depends_on "gpm" => :build

  def install
    ENV["GOPATH"] = buildpath
    mkdir_p "src/github.com/nsqio"
    ln_s buildpath, "src/github.com/nsqio/nsq"
    system "gpm", "install"
    system "make", "DESTDIR=#{prefix}", "PREFIX=", "install"
  end

  test do
    begin
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
      Process.kill(9, lookupd)
      Process.kill(9, d)
      Process.kill(9, admin)
      Process.kill(9, to_file)
      Process.wait lookupd
      Process.wait d
      Process.wait admin
      Process.wait to_file
    end
  end
end
