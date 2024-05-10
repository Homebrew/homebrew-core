class Etcd < Formula
  desc "Key value store for shared configuration and service discovery"
  homepage "https://github.com/etcd-io/etcd"
  url "https://github.com/etcd-io/etcd.git",
      tag:      "v3.5.13",
      revision: "c9063a0dcd963c89bea870eaef1d6d3af40ae26d"
  license "Apache-2.0"
  head "https://github.com/etcd-io/etcd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "417a35b0f8f7c963510e47c25e0839acded78a461af9ef99c38de95b14d535b3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "417a35b0f8f7c963510e47c25e0839acded78a461af9ef99c38de95b14d535b3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "417a35b0f8f7c963510e47c25e0839acded78a461af9ef99c38de95b14d535b3"
    sha256 cellar: :any_skip_relocation, sonoma:         "a1b70f73a5e032f6afac43c5d2df662c2e20b280502a62eda2c082018cd8b1f1"
    sha256 cellar: :any_skip_relocation, ventura:        "a1b70f73a5e032f6afac43c5d2df662c2e20b280502a62eda2c082018cd8b1f1"
    sha256 cellar: :any_skip_relocation, monterey:       "a1b70f73a5e032f6afac43c5d2df662c2e20b280502a62eda2c082018cd8b1f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac19011b9fc2544a55c2e5578ec1600c1c9f28923c452d48e23fe5649c628c8d"
  end

  depends_on "go" => :build

  def install
    system "make", "build"
    bin.install Dir[buildpath/"bin/*"]
  end

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
