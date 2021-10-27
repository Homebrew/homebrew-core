class Etcd < Formula
  desc "Key value store for shared configuration and service discovery"
  homepage "https://github.com/etcd-io/etcd"
  url "https://github.com/etcd-io/etcd.git",
      tag:      "v3.5.1",
      revision: "d42e8589e1305d893eeec9e7db746f6f4a76c250"
  license "Apache-2.0"
  head "https://github.com/etcd-io/etcd.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "668aac1a566e6927021845c8b5ae1a5c35e7eda18cfb9d034f61562f07e52751"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bca67561991cf240abc578cae54aff1638b5718c9bd119afa1a6b4463a60f6f9"
    sha256 cellar: :any_skip_relocation, monterey:       "ac2f6ea7f5dda66f52e18fa8ffef7c0e87508a8bac8285d278395a7e5a07f891"
    sha256 cellar: :any_skip_relocation, big_sur:        "f96ec40aac9729cf5688fa01399a76505920a79f8e5f9db957edc8b0c5b7470d"
    sha256 cellar: :any_skip_relocation, catalina:       "876686a80092465af3b5b638b7bf573178d8328ef5c6ce92f3e044b32ca3a4ca"
    sha256 cellar: :any_skip_relocation, mojave:         "4f8247a70bc4f030a205f839873956a3b061589aa9df88263aae279c708925f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c548dc1167dd5161c80f0de58c2ab8f4f9826278d54881d17c6105be39b59593"
  end

  depends_on "go" => :build

  def install
    system "make", "build"
    bin.install Dir[buildpath/"bin/*"]
  end

  plist_options manual: "etcd"

  service do
    environment_variables ETCD_UNSUPPORTED_ARCH: "arm64" if Hardware::CPU.arm?
    run [opt_bin/"etcd"]
    run_type :immediate
    keep_alive true
    working_dir var
  end

  test do
    test_string = "Hello from brew test!"
    etcd_pid = fork do
      on_macos do
        if Hardware::CPU.arm?
          # etcd isn't officially supported on arm64
          # https://github.com/etcd-io/etcd/issues/10318
          # https://github.com/etcd-io/etcd/issues/10677
          ENV["ETCD_UNSUPPORTED_ARCH"]="arm64"
        end
      end

      exec bin/"etcd",
        "--enable-v2", # enable etcd v2 client support
        "--force-new-cluster",
        "--logger=zap", # default logger (`capnslog`) to be deprecated in v3.5
        "--data-dir=#{testpath}"
    end
    # sleep to let etcd get its wits about it
    sleep 10

    etcd_uri = "http://127.0.0.1:2379/v2/keys/brew_test"
    system "curl", "--silent", "-L", etcd_uri, "-XPUT", "-d", "value=#{test_string}"
    curl_output = shell_output("curl --silent -L #{etcd_uri}")
    response_hash = JSON.parse(curl_output)
    assert_match(test_string, response_hash.fetch("node").fetch("value"))

    assert_equal "OK\n", shell_output("#{bin}/etcdctl put foo bar")
    assert_equal "foo\nbar\n", shell_output("#{bin}/etcdctl get foo 2>&1")
  ensure
    # clean up the etcd process before we leave
    Process.kill("HUP", etcd_pid)
  end
end
