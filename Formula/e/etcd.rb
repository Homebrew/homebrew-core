class Etcd < Formula
  desc "Key value store for shared configuration and service discovery"
  homepage "https://github.com/etcd-io/etcd"
  url "https://github.com/etcd-io/etcd.git",
      tag:      "v3.5.16",
      revision: "f20bbadd404b57c776d1e8876cefd1ac29b03fb5"
  license "Apache-2.0"
  head "https://github.com/etcd-io/etcd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "a01d8fa8acec349bedaa994c6f646b2065ae2debdd53a24dde7d7c3860942e9e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a01d8fa8acec349bedaa994c6f646b2065ae2debdd53a24dde7d7c3860942e9e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a01d8fa8acec349bedaa994c6f646b2065ae2debdd53a24dde7d7c3860942e9e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a01d8fa8acec349bedaa994c6f646b2065ae2debdd53a24dde7d7c3860942e9e"
    sha256 cellar: :any_skip_relocation, sonoma:         "1497b38b64f4385b055ce2fdffdae14dadf8a1d04e9b783127822deaeb137e64"
    sha256 cellar: :any_skip_relocation, ventura:        "1497b38b64f4385b055ce2fdffdae14dadf8a1d04e9b783127822deaeb137e64"
    sha256 cellar: :any_skip_relocation, monterey:       "1497b38b64f4385b055ce2fdffdae14dadf8a1d04e9b783127822deaeb137e64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d3789b10ec15d873628492ecf8befe7839514f3128e667a182300130478b1b1"
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
