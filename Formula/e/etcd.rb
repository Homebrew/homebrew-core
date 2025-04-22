class Etcd < Formula
  desc "Key value store for shared configuration and service discovery"
  homepage "https://github.com/etcd-io/etcd"
  url "https://github.com/etcd-io/etcd.git",
      tag:      "v3.5.21",
      revision: "a17edfd59754d1aed29c2db33520ab9d401326a5"
  license "Apache-2.0"
  head "https://github.com/etcd-io/etcd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1f7df9c92b0178937ca77e6902881e3ee68674b5a08801da80798f469cda3d18"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1f7df9c92b0178937ca77e6902881e3ee68674b5a08801da80798f469cda3d18"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1f7df9c92b0178937ca77e6902881e3ee68674b5a08801da80798f469cda3d18"
    sha256 cellar: :any_skip_relocation, sonoma:        "be8125212266c3e3c07819e542d6025060778991c973ac7c8e0adf8a47028994"
    sha256 cellar: :any_skip_relocation, ventura:       "be8125212266c3e3c07819e542d6025060778991c973ac7c8e0adf8a47028994"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "975b889dce6a6f9f45e99375e08c441c5f37b6cceab13699e76cd921a1fa8135"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "09f2a324b713c3e1dbbfde336753899e8553bf3587b8e5dc9abf79a7ef60be03"
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
