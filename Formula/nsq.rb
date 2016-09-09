require "language/go"

class Nsq < Formula
  desc "Realtime distributed messaging platform"
  homepage "http://nsq.io"
  url "https://github.com/nsqio/nsq/archive/v0.3.8.tar.gz"
  sha256 "d9107cdfe218523a74ee801caaa97968becb4b82dae7085dbb52d05c25028ff3"
  head "https://github.com/nsqio/nsq.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a47078542e18ded524af3072f7311175012611dd5f39fbfcc4b42d33e1e96ac7" => :el_capitan
    sha256 "c1de144a1b744bef456c9ac933e57d6c5dfc0779351955f23e70120cbff3d8de" => :yosemite
    sha256 "c2429649bf69d28e46d6a616c14dff1231b54791d82e8e847fd361f2907ac0d0" => :mavericks
  end

  depends_on "go" => :build

  go_resource "github.com/BurntSushi/toml" do
    url "https://github.com/BurntSushi/toml.git",
        :revision => "2dff11163ee667d51dcc066660925a92ce138deb"
  end

  go_resource "github.com/bitly/go-hostpool" do
    url "https://github.com/bitly/go-hostpool.git",
        :revision => "58b95b10d6ca26723a7f46017b348653b825a8d6"
  end

  go_resource "github.com/nsqio/go-nsq" do
    url "https://github.com/nsqio/go-nsq.git",
        :revision => "642a3f9935f12cb3b747294318d730f56f4c34b4"
  end

  go_resource "github.com/bitly/go-simplejson" do
    url "https://github.com/bitly/go-simplejson.git",
        :revision => "18db6e68d8fd9cbf2e8ebe4c81a78b96fd9bf05a"
  end

  go_resource "github.com/bmizerany/perks" do
    url "https://github.com/bmizerany/perks.git",
        :revision => "6cb9d9d729303ee2628580d9aec5db968da3a607"
  end

  go_resource "github.com/mreiferson/go-options" do
    url "https://github.com/mreiferson/go-options.git",
        :revision => "7ae3226d3e1fa6a0548f73089c72c96c141f3b95"
  end

  go_resource "github.com/mreiferson/go-snappystream" do
    url "https://github.com/mreiferson/go-snappystream.git",
        :revision => "028eae7ab5c4c9e2d1cb4c4ca1e53259bbe7e504"
  end

  go_resource "github.com/bitly/timer_metrics" do
    url "https://github.com/bitly/timer_metrics.git",
        :revision => "afad1794bb13e2a094720aeb27c088aa64564895"
  end

  go_resource "github.com/blang/semver" do
    url "https://github.com/blang/semver.git",
        :revision => "9bf7bff48b0388cb75991e58c6df7d13e982f1f2"
  end

  go_resource "github.com/julienschmidt/httprouter" do
    url "https://github.com/julienschmidt/httprouter.git",
        :revision => "6aacfd5ab513e34f7e64ea9627ab9670371b34e7"
  end

  go_resource "github.com/judwhite/go-svc" do
    url "https://github.com/judwhite/go-svc.git",
        :revision => "63c12402f579f0bdf022653c821a1aa5d7544f01"
  end

  def install
    ENV["GOPATH"] = buildpath
    Language::Go.stage_deps resources, buildpath/"src"
    mkdir_p "src/github.com/nsqio"
    ln_s buildpath, "src/github.com/nsqio/nsq"
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
      system "curl", "-d", "hello", "http://127.0.0.1:4151/put?topic=test"
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
