class Etcd < Formula
  desc "Key value store for shared configuration and service discovery"
  homepage "https://github.com/etcd-io/etcd"
  url "https://github.com/etcd-io/etcd.git",
      tag:      "v3.5.6",
      revision: "cecbe35ce0703cd0f8d2063dad4a9e541ae317e5"
  license "Apache-2.0"
  head "https://github.com/etcd-io/etcd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e4a29d70cf9e7c52cff3909b4c2c0cd801bbfb4d500009afb04143bd8e1de547"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e4a29d70cf9e7c52cff3909b4c2c0cd801bbfb4d500009afb04143bd8e1de547"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e4a29d70cf9e7c52cff3909b4c2c0cd801bbfb4d500009afb04143bd8e1de547"
    sha256 cellar: :any_skip_relocation, ventura:        "06ce94b0d467b7aab8a954f5ae1018bbee16f4cd268b77215900293f2a8c3e60"
    sha256 cellar: :any_skip_relocation, monterey:       "06ce94b0d467b7aab8a954f5ae1018bbee16f4cd268b77215900293f2a8c3e60"
    sha256 cellar: :any_skip_relocation, big_sur:        "06ce94b0d467b7aab8a954f5ae1018bbee16f4cd268b77215900293f2a8c3e60"
    sha256 cellar: :any_skip_relocation, catalina:       "06ce94b0d467b7aab8a954f5ae1018bbee16f4cd268b77215900293f2a8c3e60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff8cf0b826279321023a6f0878cbc24917b17166da75829d49dc9a47a97ab979"
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
      if OS.mac? && Hardware::CPU.arm?
        # etcd isn't officially supported on arm64
        # https://github.com/etcd-io/etcd/issues/10318
        # https://github.com/etcd-io/etcd/issues/10677
        ENV["ETCD_UNSUPPORTED_ARCH"]="arm64"
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
