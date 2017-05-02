class Nsq < Formula
  desc "Realtime distributed messaging platform"
  homepage "http://nsq.io"
  url "https://github.com/nsqio/nsq/archive/v1.0.0-compat.tar.gz"
  version "1.0.0"
  sha256 "c279d339eceb84cad09e2c2bc21e069e37988d0f6b7343d77238374081c9fd29"
  head "https://github.com/nsqio/nsq.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b5a2cd5b98623992f9b49edb1784d3d363d43be481fa4fbedab119421cc899e8" => :sierra
    sha256 "e5a1abbe2c2b5c64d12c01458c92d35b07904b07fccbcb8884be6cdad99c206b" => :el_capitan
    sha256 "3fbe85270e1dce66310d15c92d3088a8e96f4aa473ea5dc4c0b699d5758769cd" => :yosemite
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
