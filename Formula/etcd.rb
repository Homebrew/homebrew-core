class Etcd < Formula
  desc "Key value store for shared configuration and service discovery"
  homepage "https://github.com/etcd-io/etcd"
  url "https://github.com/etcd-io/etcd.git",
      tag:      "v3.5.0",
      revision: "946a5a6f25c3b6b89408ab447852731bde6e6289"
  license "Apache-2.0"
  head "https://github.com/etcd-io/etcd.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ce8803e6623bf9c2ce139f0b3a1cd94d2fd44a95c982197258fcb50b0d81d6a0"
    sha256 cellar: :any_skip_relocation, big_sur:       "6d61d2f48b71a9d79abe75c16601e5e19c73618ccee420e7ef7ca4544a30d740"
    sha256 cellar: :any_skip_relocation, catalina:      "286156f3543c75daaf30aae4da338c4382e16b3dd22ad1bf05ee90898e373843"
    sha256 cellar: :any_skip_relocation, mojave:        "e3faeef31e8635edcc01a1940421e8110405a7c04e5058d4c2392584bfa03315"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3702d7060ada44249dc7d051ac5dde7786801bff1f898c3b3c121d967db1da76"
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
