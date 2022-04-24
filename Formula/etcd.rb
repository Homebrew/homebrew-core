class Etcd < Formula
  desc "Key value store for shared configuration and service discovery"
  homepage "https://github.com/etcd-io/etcd"
  url "https://github.com/etcd-io/etcd.git",
      tag:      "v3.5.4",
      revision: "08407ff7600eb16c4445d5f21c4fafaf19412e24"
  license "Apache-2.0"
  head "https://github.com/etcd-io/etcd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f53c714853f5bb66b2b40c2d314d8674363f6f73affc4ae045c6abd77b19834e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6dc619d23a3ca33c02b8c70cd52d660f5563de3f925de0b13fcdc824da8dd94d"
    sha256 cellar: :any_skip_relocation, monterey:       "5302868bfa9084831463d1ce40aceaea88493463a33b8b438af9e02134b4e977"
    sha256 cellar: :any_skip_relocation, big_sur:        "388bf7e433a4d02f31816af3c0360162e741211ef3d60eda657232a97f0b5c47"
    sha256 cellar: :any_skip_relocation, catalina:       "071adad9324be82ef79efcc45f3f50514491a8127ef32aff38407015ad34ed3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a8d386b7c361d53ed487c7e6783276c2df3e249efe99b3cd41cdd4ff5736339b"
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
