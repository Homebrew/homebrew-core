class Etcd < Formula
  desc "Key value store for shared configuration and service discovery"
  homepage "https://github.com/etcd-io/etcd"
  url "https://github.com/etcd-io/etcd.git",
      tag:      "v3.5.20",
      revision: "ac31c34d0784b6a50a59bc125ccfcbf0ccbe5540"
  license "Apache-2.0"
  head "https://github.com/etcd-io/etcd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "83b419909835118f14fb8208eb0f47057f18025ec5d631083ab41deecc139591"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "83b419909835118f14fb8208eb0f47057f18025ec5d631083ab41deecc139591"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "83b419909835118f14fb8208eb0f47057f18025ec5d631083ab41deecc139591"
    sha256 cellar: :any_skip_relocation, sonoma:        "bc66b8190f52399be121bdef6f35575ff08141334b2a5df2937e2951e99c044a"
    sha256 cellar: :any_skip_relocation, ventura:       "bc66b8190f52399be121bdef6f35575ff08141334b2a5df2937e2951e99c044a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b3a880a13cf00156b7b6e36865fa0a6066165dc87705a552d2276fa54dbe51ec"
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
